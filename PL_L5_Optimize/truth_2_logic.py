# truth_2_logic
# I LINTED THIS WITH
# pylint3 --rcfile=pylint3rc truth_2_logic.py
# setting pylint3rc to have "constants" be ok with lowercase
# because I don't like having all variables at global scope be considered constants.

"""
truth_2_logic

Usage: Truth2Logic [-n] <inputfile>.csv [<outputfile>]")
Takes a CSV file representing a truth table from multiple inputs to multiple outputs
Emits verilog code to enact that logic
-n means don't simplify output. By default, output logic simplified with Quine-McCluskey algorithm
input and output column values must all be the same number of characters per column,
e.g. if column A is 6 bits wide, all values in that column must be 6 bits wide.
Bits for either input or output may be 0, 1, or don't-care, which is represented by x, X, or -.
"""
import csv
import sys
import re
from quine_mccluskey import qm

def extrapolate_input(instr):
    """
    Input: string
    Output: list of strings
    Given a binary input string with don'tcares, returns all the binary strings covered.
    Don'tcare can be represented by x, X, or -.
    Example:
    0110 has no don'tcares, returns only ["0110"]
    0x10 has one don'tcare, returns ["0010", "0110"]
    0x1x has two, returns ["0010", "0011", "0110", "0111"]
    etc.
    """
    outstrs = []

    # check for legality
    if re.fullmatch("[01xX-]+", instr) is None:
        print("Illegal string {} given to extrapolate_input: should contain only 0, 1, X, x, -")
        return []

    # k so count how many dontcares there are in the string
    # easiest if we normalize all dcs to X
    instr_norm = instr.replace("-", "X").upper()
    num_dc = instr_norm.count('X')
    #print("Number of dontcares in {} is {}".format(instr_norm, num_dc))
    if num_dc == 0:
        return [instr_norm]

    # at least one dc!
    # first, create a format string with %s in the place of the Xs
    instr_format = instr_norm.replace("X", "%s")
    #print("instr_format is {}".format(instr_format))
    # format for the binary strings we distribute into the output string
    formstr = "{"+"0:0>{}b".format(num_dc)+"}"
    #print("formstr = {}".format(formstr))
    for j in range(0, 2**num_dc):
        binstr = formstr.format(j)
        #print("Weaving in: {}".format(binstr))
        outy = instr_format % tuple([b for b in binstr])
        #print(outy)
        outstrs.append(outy)
    return outstrs

# MAIN ============================================================================================

if __name__ == "__main__":
    if(len(sys.argv) == 1 or (sys.argv[1] == "-n" and len(sys.argv) == 2)):
        print("Usage: Truth2Logic [-n] <inputfile>.csv [<outputfile>]")
        print("Takes a CSV file representing a truth table from multiple inputs",
              "to multiple outputs")
        print("Emits verilog code to enact that logic")
        print("-n means don't simplify output. By default, output logic simplified with ",
              "Quine-McCluskey algorithm")
        print("input and output column values must all be the same number of characters ",
              "per column, e.g. if column A")
        print("is 6 bits wide, all values in that column must be 6 bits wide.")
        print("Bits for either input or output may be 0, 1, or don't-care, which is represented ",
              "by x, X, or -.")
        sys.exit(1)

    # Set up globals!
    do_simplify = True
    outfile = "Truth2Logic_out.txt"
    if sys.argv[1] == "-n":
        do_simplify = False
        infile = sys.argv[2]
        if len(sys.argv) > 3:
            outfile = sys.argv[3]
    else:
        infile = sys.argv[1]
        if len(sys.argv) > 2:
            outfile = sys.argv[2]

    print("Input file: {}".format(infile))
    print("Output file: {}".format(outfile))
    print("Simplify with Quine-McCluskey: {}".format(do_simplify))

    # inputcols are names of columns representing inputs, in the order given. Similar outputcols.
    # understood that the index of input columns is 0..outindex-1, output columns is
    # outindex+1..len(colnames)-1
    # input/outputwidths is the bit widths of the corresponding columns
    colnames = []
    inputcols = []
    inputwidths = []
    outputcols = []
    outputwidths = []
    total_input_bits = 0
    total_output_bits = 0
    outindex = -1
    # invals and outvals are dict from column name to a list of the values for that column, in
    #order read from the file.
    invals = {}
    outvals = {}

    with open(infile) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',', skipinitialspace=True)
        line_count = 0

        for quotedrow in csv_reader:
            row = [col.strip('"') for col in quotedrow]  # remove quotes csv export may have added
            if line_count == 0:
                colnames = row
                print('Column names are {}'.format("|".join(colnames)))
                # here, note which are inputs and outputs.
                # require that there be a column called OUT in all caps somewhere
                if "OUT" not in colnames:
                    print("ERROR: there needs to be a column named OUT between inputs and outputs")
                    sys.exit(1)
                else:
                    # we have OUT; anything before it is an input, anything after is an output.
                    outindex = colnames.index("OUT")             # we know it's there
                    inputcols = colnames[:outindex]
                    outputcols = colnames[outindex+1:]
                    print("Outindex: {} Inputs: {} outputs: {}"\
                        .format(outindex, "|".join(inputcols), "|".join(outputcols)))
                    # initialize values lists
                    invals = {c:[] for c in inputcols}
                    outvals = {c:[] for c in outputcols}
            else:
                #print("|".join(row))                                # verbose debug
                # sanity check
                if len(row) != len(colnames):
                    print("wrong number of columns ({}) in line {}, should be {}"\
                        .format(len(row), line_count+1, len(colnames)))
                    sys.exit(1)
                # if it's the first line of data we read, it defines the bit-widths of the columns.
                if line_count == 1:
                    inputwidths = [len(row[i]) for i in range(0, outindex)]
                    total_input_bits = sum(inputwidths)
                    outputwidths = [len(row[i]) for i in range(outindex+1, len(colnames))]
                    total_output_bits = sum(outputwidths)
                    for i in range(0, outindex):
                        print("input column {} has width {}".format(colnames[i], inputwidths[i]))
                    for i in range(outindex+1, len(colnames)):
                        print("output column {} has width {}"\
                            .format(colnames[i-(outindex+1)], outputwidths[i-(outindex+1)]))

                # check bit widths against those recorded and make sure it's all binary
                for i in range(0, outindex):
                    if len(row[i]) != inputwidths[i]:
                        print("Line {} Column '{}' has incorrect width {}, should be {}"\
                            .format(line_count+1, colnames[i], len(row[i]), inputwidths[i]))
                        sys.exit(1)
                    #HERE CHECK TO SEE THAT THE STRING IS ALL 0,1... looks like "don't care" in
                    # the quine-mcc implementation means that the OUTPUT doesn't matter.
                    # only wait, see below where I ponder that don't-cares on the input are
                    # handled as preprocessing of input
                    # to the qmc simplification, so they're ok in input too.
                    elif re.fullmatch("[01xX-]+", row[i]) is None:
                        print("Line {} Column '{}'".format(line_count+1, colnames[i]),
                              "contains illegal characters (should be all ",
                              "0s, 1s, -s and Xs, is \"{}\")".format(row[i]))
                        sys.exit(1)
                    else:
                        invals[inputcols[i]].append(row[i])

                for i in range(outindex+1, len(colnames)):
                    if len(row[i]) != outputwidths[i-(outindex+1)]:
                        print("Line {} Column '{}' has incorrect width {}, should be {}"\
                            .format(line_count+1, colnames[i], len(row[i]),
                                    outputwidths[i-(outindex+1)]))
                        sys.exit(1)
                    # OUTPUTS CAN HAVE Xs/-s that will be passed to qm's "don't cares" list
                    elif re.fullmatch("[01xX-]+", row[i]) is None:
                        print("Line {} Column '{}'".format(line_count+1, colnames[i]),
                              "contains illegal characters (should be all ",
                              "0s, 1s, -s and Xs, is \"{}\")".format(row[i]))
                        sys.exit(1)
                    else:
                        outvals[outputcols[i-(outindex+1)]].append(row[i])
            line_count += 1
        print('Processed {} lines.'.format(line_count))

    # now we have nice sanity checked lines.
    # let's construct the raw inputs and outputs therefrom!
    # Well, let's actually think out what's going to happen.
    # - so, we need a way to turn a binary string into a Verilog equation.
    #   binary string should also support having - in it, like output of the qm simplify does.
    # - Need a function to relate a bit from binary string w/var name and index it represents,
    #   e.g. if we have an input called A that's 3 bits wide, the MSB is a[2], LSB is a[0].
    # - if the bit is a 0, emit e.g. ~a[2], if a 1 emit e.g. a[2].
    # - If it's a - or x or X,
    #   - THINK ABOUT THIS. What if we had an input of 1x1x meaning a certain output bit is 1?
    #     that would mean that there are 4 inputs that lead to a 1: 1010, 1011, 1110, 1111
    # - so generate all the numbers (i.e. decimal version of the concatenated inputs with
    #   don'tcares subbed in all possible ways) for every input that's 1 or dc in the output bit
    #   of interest
    # - then make sure each list is all unique values, conceivable there would be overlap in the
    #   extrapolated don'tcares
    #   - let's say it's an error if any input values collide - maybe only if output differs,
    #     in which case warn, but still
    #   - MAKE SURE ALL INPUT VALUES ARE COVERED? yeah do

    # so: step through all the lines and construct the full input and output vectors.
    numcases = line_count-1        # because the first line is column names.

    print("Extrapolated rows:")
    extrapolated_rows = {}
    for c in range(0, numcases):
        # first, figure out output string
        concat_outs = ""
        for i, ocol in enumerate(outputcols):
            # same for output wrt concatenating, but don't worry about extrapolating
            concat_outs += outvals[ocol][c]
        # then build extrapolated rows for which that is the output
        concat_ins = ""
        for i, icol in enumerate(inputcols):
            # concatenate the values from the input for this row to get the whole input
            # extrapolate don't cares in the input and add all new cases to extrapolated_rows
            # IF THE INPUT VALUE ALREADY EXISTS, YELL
            # preserve order in extrapolated_inputs - can check full coverage by whether its
            # length is 2^number of input bits
            concat_ins += invals[icol][c]
        #inputs.extend(extrapolate_input(concat_ins))   easy way to extend, but we need
        # to check for duplicates.
        extrap_errors = False
        extrap_input = extrapolate_input(concat_ins)
        for newin in extrap_input:
            if newin in extrapolated_rows:
                print("ERROR: input {} occurs more than once".format(newin))
                extrap_errors = True
            else:
                print("Row {}: input {} output {}".format(c, newin, concat_outs))
                extrapolated_rows[newin] = concat_outs
        if extrap_errors:
            print("ERROR: duplicated row(s)")
            sys.exit(1)

    # check that all cases are covered - if more than all of them are covered, we would
    # have gotten a duplicated row error
    iformstr = "{"+"0:0>{}b".format(total_input_bits)+"}"
    if len(extrapolated_rows) < 2**total_input_bits:
        print("ERROR: some input values unaccounted for")
        # report *which* inputs are missing
        for n in range(2**total_input_bits):
            if iformstr.format(n) not in extrapolated_rows:
                print("Input {} not represented".format(iformstr.format(n)))
        sys.exit(1)

    # now to build the logic!
    # - for non-simplified output (testing to see if toolchain optimizing does a better job than
    #   this script), don't call Quine-McCluskey

    # so, we need to iterate over the bits of output. I guess let's build lists of the input and
    # output bit names.
    input_bit_names = []
    output_bit_names = []

    # if a field's width is 1 bit, just emit its name. Otherwise emit name and [bit] in
    # descending order.
    for i, icol in enumerate(inputcols):
        if inputwidths[i] == 1:
            input_bit_names.append(icol)
        else:
            for q in range(inputwidths[i]-1, -1, -1):
                input_bit_names.append("{}[{}]".format(icol, q))

    for i, ocol in enumerate(outputcols):
        if outputwidths[i] == 1:
            output_bit_names.append(ocol)
        else:
            for q in range(outputwidths[i]-1, -1, -1):
                output_bit_names.append("{}[{}]".format(ocol, q))

    print("Input bit names: {}".format("|".join(input_bit_names)))
    print("Output bit names: {}".format("|".join(output_bit_names)))

    # now to start building the actual logic! w00tles!
    if do_simplify is False:
        # non-simplified version:
        # for each output bit:
        #   for each input:
        #     if the output bit is a 1 for this input, add the input string to the ones array
        #     if the output bit is a X, die? What is the correct thing to do? Could just ignore
        #       the input for that row, I guess, which makes it a 0? ??? Let's say die.
        # result is a ones array of binary strings e.g. ["010", "101"] where the inputs are
        # A and B[1:0] so the logic for that bit is
        # out[bit] = (~A & B[1] & ~B[0]) + (A & ~B[1] & B[0])
        # this is a slow gross way to do it but wev
        for o, obit_name in enumerate(output_bit_names):
            ones_inputstrs = []
            for rownum in range(2**total_input_bits):
                inny = iformstr.format(rownum)
                outstr = extrapolated_rows[inny]
                if outstr[o] == '1':
                    ones_inputstrs.append(inny)
                elif outstr[o] == 'x' or outstr[o] == 'X' or outstr[o] == '-':
                    print("ERROR: non-simplified mode shouldn't be used if outputs have dontcares")
                    sys.exit(1)
            print("Inputs where output bit {} is 1: {}".format(obit_name, "|".join(ones_inputstrs)))
            # THAT SHOULD BE ALL WE NEED TO DO THE CONVERSION
            # TODO: HERE PUT THE PART THAT EMITS THE LOGIC FOR THAT OUTPUT BIT!
    else:
        # for quine_mccluskey version, need to build the form it wants - which can be strings
        # in simplify_los:
        # def simplify_los(self, ones, dc = [], num_bits = None):
        #     """The simplification algorithm for a list of string-encoded inputs.
        #     Args:
        #         ones (list of str): list of strings that describe when the output
        #         function is '1', e.g. ['0001', '0010', '0110', '1000', '1111'].
        #     Kwargs:
        #         dc: (list of str): list of strings that define the don't care
        #         combinations.
        #
        # recall that invocation is something like this
        # >>> from quine_mccluskey import qm
        # >>> myqm = qm.QuineMcCluskey(False)
        # >>> myqm.simplify([0,2,3,5,6,8,9,11,12,13,14,16,18,19,21,22,24,25],num_bits=5)
        # {'-00-0', '-0101', '-001-', '010-1', '01-0-', '-0-10', '0-110', '-100-'}
        myqm = qm.QuineMcCluskey(False)
        for o, obit_name in enumerate(output_bit_names):
            ones_inputstrs = []
            dc_inputstrs = []
            for rownum in range(2**total_input_bits):
                inny = iformstr.format(rownum)
                outstr = extrapolated_rows[inny]
                if outstr[o] == '1':
                    ones_inputstrs.append(inny)
                elif outstr[o] == 'x' or outstr[o] == 'X' or outstr[o] == '-':
                    dc_inputstrs.append(inny)
            print("Inputs where output bit {} is 1: {}".format(obit_name, "|".join(ones_inputstrs)))
            # TODO: make an input file with some X in the output
            if len(dc_inputstrs) > 0:
                print("Inputs where output bit {} is X: {}".format(obit_name, "|".join(dc_inputstrs)))
            # THAT SHOULD BE ALL WE NEED TO DO THE CONVERSION
            # call quine_mccluskey thing to simplify!
            sim = myqm.simplify_los(ones_inputstrs, dc=dc_inputstrs, num_bits=total_input_bits)
            print("Result from myqm: {}".format("|".join(sim)))
            # TODO: HERE PUT THE PART THAT EMITS THE LOGIC FOR THAT OUTPUT BIT!

def emit_logic(obit_name, input_bit_names, inputs):
    # TODO WRITE THIS!!!!!!!!!!!!!!!!!!!11
    pass

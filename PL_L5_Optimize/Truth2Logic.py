import csv
import sys
import re
from quine_mccluskey import qm

if __name__ == "__main__":
    if(len(sys.argv) == 1 or (sys.argv[1] == "-n" and len(sys.argv) == 2)) :
        print("Usage: Truth2Logic [-n] <inputfile>.csv [<outputfile>]")
        print("Takes a CSV file representing a truth table from multiple inputs to multiple outputs")
        print("Emits verilog code to enact that logic")
        print("-n means don't simplify output. By default, output logic simplified with Quine-McCluskey algorithm")
        print("input and output column values must all be the same number of characters per column, e.g. if column A")
        print("is 6 bits wide, all values in that column must be 6 bits wide.")
        print("Bits for either input or output may be 0, 1, or don't-care, which is represented by x, X, or -.")
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

    # inputcols are the names of columns representing inputs, in the order given. Similar outputcols.
    # understood that the index of input columns is 0..outindex-1, output columns is outindex+1..len(colnames)-1
    # input/outputwidths is the bit widths of the corresponding columns
    colnames = []
    inputcols = []
    inputwidths = []
    outputcols = []
    outputwidths = []
    outindex = -1
    # invals and outvals are dict from column name to a list of the values for that column, in order read from the file.
    invals = {}
    outvals = {}

    with open(infile) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',',skipinitialspace=True)
        line_count = 0

        for quotedrow in csv_reader:
            row = [col.strip('"') for col in quotedrow]             # get rid of quotes that csv export may have added
            if line_count == 0:
                colnames = row
                print(f'Column names are {"|".join(colnames)}')
                # here, note which are inputs and outputs.
                # require that there be a column called OUT in all caps somewhere
                if "OUT" not in colnames:
                    print("ERROR: there needs to be a column named OUT between inputs and outputs")
                    sys.exit(1)
                else:
                    # K we have an OUT; anything before it in the list is an input, anything after is an output.
                    outindex = colnames.index("OUT")             # we know it's there
                    inputcols = colnames[:outindex]
                    outputcols = colnames[outindex+1:]
                    print("Outindex: {} Inputs: {} outputs: {}".format(outindex, "|".join(inputcols),"|".join(outputcols)))
                    # initialize values lists
                    invals = {c:[] for c in inputcols}
                    outvals = {c:[] for c in outputcols}
            else:
                print("|".join(row))                                # verbose debug
                # sanity check
                if len(row) != len(colnames):
                    print("wrong number of columns ({}) in line {}, should be {}".format(len(row), line_count+1, len(colnames)))
                    sys.exit(1)
                # if it's the first line of data we read, it defines the bit-widths of the columns.
                # WHAT DO I DO WITH THEM?!?!??!?!?!?
                if line_count == 1:
                    inputwidths = [len(row[i]) for i in range(0,outindex)]
                    outputwidths = [len(row[i]) for i in range(outindex+1, len(colnames))]
                    for i in range(0,outindex):
                        print("input column {} has width {}".format(i,inputwidths[i]))
                    for i in range(outindex+1, len(colnames)):
                        print("output column {} has width {}".format(i-(outindex+1),outputwidths[i-(outindex+1)]))
                else:
                    # check bit widths against those recorded and make sure it's all binary
                    # TODO: make a function that does this and clean this up?
                    for i in range(0,outindex):
                        if len(row[i]) != inputwidths[i]:
                            print("Line {} Column '{}' has incorrect width {}, should be {}".format(line_count+1,colnames[i],len(row[i]),inputwidths[i]))
                            sys.exit(1)
                        #HERE CHECK TO SEE THAT THE STRING IS ALL 0,1... looks like "don't care" in the quine-mcc implementation means
                        # that the OUTPUT doesn't matter.
                        # only wait, see below where I ponder that don't-cares on the input are handled as preprocessing of input
                        # to the qmc simplification, so they're ok in input too.
                        elif re.fullmatch("[01xX\-]+",row[i]) is None:
                            print("Line {} Column '{}' contains illegal characters (should be all 0s, 1s, -s and Xs, is \"{}\")".format(line_count+1,colnames[i],row[i]))
                            sys.exit(1)
                        else:
                            invals[inputcols[i]].append(row[i])
                    for i in range(outindex+1, len(colnames)):
                        if len(row[i]) != outputwidths[i-(outindex+1)]:
                            print("Line {} Column '{}' has incorrect width {}, should be {}".format(line_count+1,colnames[i],len(row[i]),outputwidths[i-(outindex+1)]))
                            sys.exit(1)
                        # OUTPUTS CAN HAVE Xs in them, that will be passed to qm's "don't cares" list
                        elif re.fullmatch("[01xX\-]+",row[i]) is None:
                            print("Line {} Column '{}' contains illegal characters (should be all 0s, 1s, -s, and Xs, is \"{}\")".format(line_count+1,colnames[i],row[i]))
                            sys.exit(1)
                        else:
                            outvals[outputcols[i-(outindex+1)]].append(row[i])
            line_count += 1
        print(f'Processed {line_count} lines.')

        # now we have nice sanity checked lines.
        # let's construct the raw inputs and outputs therefrom!
        # Well, let's actually think out what's going to happen.
        # - so, we need a way to turn a binary string into a Verilog equation.
        #   the binary string should also support having - in it, like the output of the qm simplify does.
        # - Need a function to associate a bit from the binary string with the variable name and index it represents,
        #   e.g. if we have an input called A that's 3 bits wide, we know the MSB is a[2], LSB is a[0].
        # - if the bit is a 0, emit e.g. ~a[2], if a 1 emit e.g. a[2]. If it's a - or x or X, depends on what we're doing.
        #   - if we're doing unsimplified logic... could emit a 0 or a 1 or random or ??? but I think even in that
        #     case just don't emit anything. That could conceivably work on the input side too, right?
        #   - THINK ABOUT THIS. What if we had an input of 1x1x meaning a certain output bit is 1?
        #     that would mean that there are 4 inputs that lead to a 1: 1010, 1011, 1110, 1111
        # - so generate all the numbers (i.e. decimal version of the concatenated inputs with don'tcares subbed in all possible
        #   ways) for every input that's 1 or dc in the output bit of interest
        # - then make sure each list is all unique values, conceivable there would be overlap in the extrapolated don'tcares
        # - for non-simplified output (testing to see if toolchain optimizing does a better job than this script),
        #   don't call Quine-McCluskey
        # TODO WRAP THIS UP AND WRITE IT

import csv
import sys

if __name__ == "__main__":
    if(len(sys.argv) == 1) :
        print("Usage: CSV2Logic <inputfile>.csv [<outputfile>]")
        print("Takes a CSV file representing a truth table from multiple inputs to multiple outputs")
        print("Emits verilog code to enact that logic")
        sys.exit(1)


    # right so here is the basic code from https://realpython.com/python-csv/#reading-csv-files-with-csv which I will
    # hack up into what I want.
    infile = sys.argv[1]
    with open(infile) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',',skipinitialspace=True)
        line_count = 0

        for quotedrow in csv_reader:
            row = [col.strip('"') for col in quotedrow]
            if line_count == 0:
                print(f'Column names are {"|".join(row)}')
                line_count += 1
            else:
                print("|".join(row))
                line_count += 1
        print(f'Processed {line_count} lines.')

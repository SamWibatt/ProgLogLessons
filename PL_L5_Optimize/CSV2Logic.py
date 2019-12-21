import csv
import sys

if __name__ == "__main__":
    if(len(sys.argv) == 1) :
        print("Usage: CSV2Logic <inputfile>.csv [<outputfile>]")
        print("Takes a CSV file representing a truth table from multiple inputs to multiple outputs")
        print("Emits verilog code to enact that logic")
        sys.exit(1)
    infile = sys.argv[1]
    with open(infile) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        for row in csv_reader:
            if line_count == 0:
                print(f'Column names are {", ".join(row)}')
                line_count += 1
            else:
                print(f'\t{row[0]} works in the {row[1]} department, and was born in {row[2]}.')
                line_count += 1
        print(f'Processed {line_count} lines.')

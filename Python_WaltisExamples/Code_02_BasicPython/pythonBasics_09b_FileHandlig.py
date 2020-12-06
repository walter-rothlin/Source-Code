def File_getCountOfLines(sourceFileFN):
    lines = []
    with open(sourceFileFN, "r") as f:
        lines = f.readlines()
    return len(lines)


def File_deleteLines(sourceFileFN, destinationFileFN=None, deleteLineFrom=None, deleteLineTo=None, verbal=False):
    if destinationFileFN is None:
        destinationFileFN = sourceFileFN

    if (deleteLineFrom is None) and (deleteLineTo is None):
        deleteLineFrom = 0
        deleteLineTo = 0
    elif (deleteLineFrom is not None) and (deleteLineTo is None):
        deleteLineTo = 1000000
    elif (deleteLineFrom is None) and (deleteLineTo is not None):
        deleteLineFrom = 0
    else:
        pass  # NOP

    if verbal:
        print("    Delete from", deleteLineFrom, "to", deleteLineTo, end="")
    with open(sourceFileFN, "r") as f:
        lines = f.readlines()

    with open(destinationFileFN, "w") as f:
        i = 1
        for line in lines:
            if (i < deleteLineFrom) or (i > deleteLineTo):
                f.write(line)
            i += 1


if __name__ == '__main__':
    testfile_1 = "./weatherLog.txt"
    testfile_2 = "./weatherLogCopy.txt"

    deleteLineFrom = 3
    deleteLineTo   = 5

    print(File_getCountOfLines(testfile_1))
    File_deleteLines(testfile_1, destinationFileFN=testfile_2)
    # File_deleteLines(testfile_1, destinationFileFN=testfile_2,                                deleteLineTo=deleteLineTo)
    # File_deleteLines(testfile_1, destinationFileFN=testfile_2, deleteLineFrom=deleteLineFrom)
    File_deleteLines(testfile_1, destinationFileFN=testfile_2, deleteLineFrom=deleteLineFrom, deleteLineTo=deleteLineTo)
    print(File_getCountOfLines(testfile_2))

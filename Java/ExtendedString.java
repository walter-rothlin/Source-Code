package com.rothlin.io;

import java.text.SimpleDateFormat;
import java.util.*;
import java.text.*;

public class ExtendedString {

	public static void main(String[] args) {
		// test_getEndOfFloatStr();
		// test_getEndOfIdentifier();
		// test_markerPosInString();
		// test_padString();
		test_classHierarchyToString();
		test_AsciiTableFormat();
	}

	public static String getTimestamp(String format) {
		GregorianCalendar nowTime = new GregorianCalendar();
		SimpleDateFormat dateFormat = new java.text.SimpleDateFormat(format);
		return "";
	}

	public static String getTimestamp() {
		return getTimestamp("dd-MM-yyyy HH:mm:ss");
	}

	public static void test_padString() {
		String str1 = "T";
		System.out.println(str1 + '\n' + padString(str1, 5, '.'));
	}

	public static String padString(String inStr, int len) {
		return padString(inStr, len, ' ');
	}

	public static String padString(String inStr, int len, char padChr) {
		StringBuffer retString = new StringBuffer(inStr);
		while (retString.length() < len) {
			retString.append(padChr);
		}
		return retString.toString();
	}
	
	public static String unterstreichen(String titleStr) {
		return titleStr + "\n" + padString("",titleStr.length(),'=');
	}

	public static void test_markerPosInString() {
		String str1 = "Tobias, Lukas + Walti";
		int markPos[] = { 6, 14 };
		System.out.println(str1 + '\n' + markPosInString(str1, markPos));
		System.out.println(str1 + '\n' + markPosInString(str1, 6));
	}

	public static String getMarkedString(String inStr, int markerPos) {
		return inStr + '\n' + markPosInString(inStr, markerPos);
	}

	public static String markPosInString(String inStr, int markerPos) {
		int markers[] = { markerPos };
		return markPosInString(inStr, markers, '^', '-');
	}

	public static String markPosInString(String inStr, int[] markers) {
		return markPosInString(inStr, markers, '^', '-');
	}

	public static String markPosInString(String inStr, int[] markers, char markChar, char lineChr) {
		Arrays.sort(markers);
		StringBuffer retString = new StringBuffer();
		int lastMarkerPos = markers[markers.length - 1];
		int k = 0;
		for (int i = 0; i <= lastMarkerPos; i++) {
			if (i == markers[k]) {
				retString.append(markChar);
				k++;
			} else {
				retString.append(lineChr);
			}
		}
		return retString.toString();
	}

	public static int getEndOfFloatStr(String floatStr) {
		return getEndOfFloatStr(floatStr, 0);
	}

	public static int getEndOfFloatStr(String floatStr, int startPos) {
		int pos = startPos;
		boolean hasVorkommaStellen = false;
		boolean hasNachkommaStellen = false;
		boolean hasExponent = false;

		if (floatStr.length() == 0)
			return 0;
		// Vorkomma behandeln
		if ((floatStr.charAt(pos) == '+') || (floatStr.charAt(pos) == '-')) {
			pos++;
			if (!((floatStr.charAt(pos) >= '0') && (floatStr.charAt(pos) <= '9'))) {
				return 0;
			}
		}
		while (((floatStr.charAt(pos) >= '0') && (floatStr.charAt(pos) <= '9')) || (floatStr.charAt(pos) == '\'')) {
			pos++;
			if (pos >= floatStr.length())
				return pos;
			if (floatStr.charAt(pos) != '\'') {
				hasVorkommaStellen = true;
			}
		}
		// Komma ?
		if ((floatStr.charAt(pos) == '.') || (floatStr.charAt(pos) == ',')) {
			pos++;
			// Falls noch keine Vorkommastellen enthalten sind muss nun zwingend
			// eine Zahl folgen
			if (!(hasVorkommaStellen)) {
				if (!((floatStr.charAt(pos) >= '0') && (floatStr.charAt(pos) <= '9'))) {
					return 0;
				}
			}
		} else {
			return pos;
		}
		// Nachkommastellen
		while ((floatStr.charAt(pos) >= '0') && (floatStr.charAt(pos) <= '9')) {
			pos++;
			if (pos >= floatStr.length())
				return pos;
			if ((floatStr.charAt(pos) >= '0') && (floatStr.charAt(pos) <= '9')) {
				hasNachkommaStellen = true;
			}
		}

		if ((hasNachkommaStellen) || (hasVorkommaStellen)) {
			;
		} else {
			return 0;
		}
		// Exponent behandeln
		if ((floatStr.charAt(pos) == 'E') || (floatStr.charAt(pos) == 'e')) {
			pos++;
		} else {
			return pos;
		}
		if ((floatStr.charAt(pos) == '+') || (floatStr.charAt(pos) == '-')) {
			pos++;
		}
		while (((floatStr.charAt(pos) >= '0') && (floatStr.charAt(pos) <= '9')) || (floatStr.charAt(pos) == '\'')) {
			pos++;
			if (pos >= floatStr.length())
				return pos;
		}
		return pos;
	}

	public static boolean test_getEndOfFloatStr() {
		String floatStr = "";

		String[] testCasesOK = { "12345", "-12324 + 234", "+234566asdert", "-12'333'333.0", "+123'333.00567",
				"-12'345.678e-12", "+12'222.45e+3", "qwer", "+awer", ".aaaaa", "" };
		for (int i = 0; i < testCasesOK.length; i++) {
			int pos = getEndOfFloatStr(testCasesOK[i]);
			// System.out.println("pos = " + pos);
			if (pos == 0) {
				System.out.println(testCasesOK[i] + " ist keine Zahl!!");
			} else {
				String realStr = (testCasesOK[i].substring(0, pos)).replaceAll("'", "");
				System.out.println(testCasesOK[i] + " = " + realStr + " ==> " + Double.parseDouble(realStr));
			}
			// System.out.println();
		}
		return true;
	}

	public static int getEndOfIdentifier(String identifierStr) {
		return getEndOfIdentifier(identifierStr, 0);
	}

	public static int getEndOfIdentifier(String identifierStr, int startPos) {
		int pos = startPos;
		if (identifierStr.length() == 0)
			return 0;
		// Muss mit Buchstabe 'A'..'Z', 'a'..'z', '_','$' beginnen
		if (((identifierStr.toUpperCase().charAt(pos) >= 'A') && (identifierStr.toUpperCase().charAt(pos) <= 'Z'))
				|| (identifierStr.charAt(pos) == '_') || (identifierStr.charAt(pos) == '$')) {
			pos++;
			if (pos >= identifierStr.length())
				return pos;
		}
		while (((identifierStr.toUpperCase().charAt(pos) >= 'A') && (identifierStr.toUpperCase().charAt(pos) <= 'Z'))
				|| ((identifierStr.charAt(pos) >= '0') && (identifierStr.charAt(pos) <= '9'))
				|| (identifierStr.charAt(pos) == '_') || (identifierStr.charAt(pos) == '$')) {
			pos++;
			if (pos >= identifierStr.length())
				return pos;
		}
		return pos;
	}

	public static boolean test_getEndOfIdentifier() {

		String[] testCasesOK = { "walti4569", "-12324 + 234", "+234566asdert", "-12'333'333.0", "+123'333.00567",
				"-12'345.678e-12", "+12'222.45e+3", "qwer", "+awer", ".aaaaa", "", "$___453awAA", "Walti56_67",
				"03Walti", "_Walti$5" };
		for (int i = 0; i < testCasesOK.length; i++) {
			int pos = getEndOfIdentifier(testCasesOK[i]);
			// System.out.println("pos = " + pos);
			if (pos == 0) {
				System.out.println(testCasesOK[i] + " ist kein Identifier!!");
			} else {
				String identifierStr = (testCasesOK[i].substring(0, pos));
				System.out.println(testCasesOK[i] + " = " + identifierStr);
			}
			// System.out.println();
		}
		return true;
	}

	/**
	 * Formating to Hex or Binary string
	 */
	// Methods for Bit-String formatting
	public static String formatedBinaryString(byte val) {
		return formatedBinaryString(val, 1);
	}

	public static String formatedBinaryString(short val) {
		return formatedBinaryString(val, 2);
	}

	public static String formatedBinaryString(char val) {
		return formatedBinaryString(val, 2);
	}

	public static String formatedBinaryString(int val) {
		return formatedBinaryString(val, 4);
	}

	public static String formatedBinaryString(long val) {
		return formatedBinaryString(val, 8);
	}

	public static String formatedBinaryString(long pNumber, int pBytes) {
		StringBuffer binaryStr = new StringBuffer(Long.toBinaryString(pNumber));
		int noOfNullBits = (pBytes * 8) - binaryStr.length();
		for (int i = 0; i < noOfNullBits; i++) {
			binaryStr.insert(0, "0");
		}
		if (noOfNullBits < 0) {
			binaryStr = new StringBuffer(binaryStr.substring(binaryStr.length() - pBytes * 8));
		}
		for (int i = 1; i < pBytes; i++) {
			binaryStr.insert(i * 8 + (i - 1), " ");
		}
		return binaryStr.toString();
	}

	// Methods for Hex-String formatting
	public static String formatedHexString(byte val) {
		return formatedHexString(val, 1);
	}

	public static String formatedHexString(short val) {
		return formatedHexString(val, 2);
	}

	public static String formatedHexString(char val) {
		return formatedHexString(val, 2);
	}

	public static String formatedHexString(int val) {
		return formatedHexString(val, 4);
	}

	public static String formatedHexString(long val) {
		return formatedHexString(val, 8);
	}

	public static String formatedHexString(long pNumber, int pBytes) {
		StringBuffer hexStr = new StringBuffer(Long.toHexString(pNumber));
		System.out.println("pNumber: " + pNumber + "  pNumberHexStr: " + hexStr);
		int requestedLength = pBytes * 2;
		if (hexStr.length() > requestedLength) {
			hexStr = new StringBuffer(hexStr.substring(hexStr.length() - requestedLength));
		} else if (hexStr.length() < requestedLength) {
			while (hexStr.length() < requestedLength) {
				hexStr.insert(0, "0");
			}
		}
		return hexStr.toString();
	}

	// ===================
	// Exception functions
	// ===================

	public static String classHierachyToString(Object obj, String classSep, String lineMarker) {
		StringBuffer sep = new StringBuffer(lineMarker);
		StringBuffer clsString = new StringBuffer();
		Class cls;
		cls = obj.getClass();
		do {
			clsString.append(sep + ">" + cls.getName() + classSep);
			sep.append(lineMarker);
		} while (((cls = cls.getSuperclass()) != null) && (!cls.getName().equals("Object")));
		return clsString.toString();
	}

	public static void test_classHierarchyToString() {
		Exception testClass = new Exception();
		System.out.println(classHierachyToString(testClass, "\n", "-"));
	}

	/**
	 * Repeats the given string the given amount of times.
	 * 
	 * @param toRepeat
	 *            the string to be repeated.
	 * @param repeatCount
	 *            the amount of times the string should be repeated
	 * @return the given string repeated given amount of times all concatenated
	 *         together.
	 */
	public static String getRepeatingString(int repeatCount, String toRepeat) {
		StringBuilder resultBuilder = new StringBuilder();
		for (int i = 1; i <= repeatCount; i++) {
			resultBuilder.append(toRepeat);
		}
		return resultBuilder.toString();
	}

	public static String getRepeatingString(int repeatCount, char... toRepeat) {
		return getRepeatingString(repeatCount, new String(toRepeat));
	}

	// ===================
	// 	AsciiTableFormat
	// ===================
	public static String asciiFormatTable(String[][] tableData, int gapSize, char horizontalLine, char verticalLine, char corner) {
		String gap = getRepeatingString(gapSize, " ");

		List<Integer> columnWidth = new ArrayList<>();
		for (String[] row : tableData) {
			for (int columnIndex = 0; columnIndex < row.length; columnIndex++) {
				String field = row[columnIndex];
				if (columnWidth.size() <= columnIndex)
					columnWidth.add(field.length());
				else if (columnWidth.get(columnIndex) < field.length())
					columnWidth.set(columnIndex, field.length());
			}
		}

		StringBuilder horizontalSeparator = new StringBuilder();
		horizontalSeparator.append(corner);
		for (int width : columnWidth)
			horizontalSeparator.append(getRepeatingString(width + 2, horizontalLine) + corner);

		StringBuilder table = new StringBuilder();

		table.append(horizontalSeparator + "\n");
		for (String[] row : tableData) {
			for (int columnIndex = 0; columnIndex < row.length; columnIndex++) {
				String field = row[columnIndex];
				table.append(verticalLine + gap + field
						+ getRepeatingString(columnWidth.get(columnIndex) - field.length(), " ") + gap);
			}
			table.append(verticalLine + "\n" + horizontalSeparator + "\n");
		}
		table.deleteCharAt(table.lastIndexOf("\n")); // Delete the last line
														// break again since
														// it's not required

		return table.toString();
	}

	public static String asciiFormatTable(String[][] tableData, int gapSize) {
		char horizontalLine = '-';
		char verticalLine = '|';
		char corner = '+';
		return asciiFormatTable(tableData, gapSize, horizontalLine, verticalLine, corner);
	}

	public static String asciiFormatTable(String[][] tableData) {
		int gapSize = 1;
		return asciiFormatTable(tableData, gapSize);
	}

	public static void test_AsciiTableFormat() {
		String[][] table = { { "1234", "123456", "12" }, { "12345", "1", "123456789" }, { "1", "123", "12" } };
		System.out.println(asciiFormatTable(table, 1));
	}

}

package com.rothlin.hwz;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Savepoint;
import java.util.Properties;
import java.util.Scanner;

import com.rothlin.io.ExtendedIO;
import com.rothlin.io.ExtendedString;

/* Belongs to project: HWZ_DB_Connection */
/* ===================================== */

public class Main_6_Transactions {
	private Scanner in = new Scanner(System.in);
	private Properties connectionProperties = new Properties();
	private int zuGunstenId = 2;
	private int zuLastenId = 4;
	private double zuGunstenStand = 2000.0;
	private double zuLastenStand = 5000.0;
	private double transaktionsBetrag = 1234.50;
	
	
	public Main_6_Transactions() throws SQLException, ClassNotFoundException {
		connectionProperties.put("user", "root");
		connectionProperties.put("password", "admin");
		connectionProperties.put("useSSL", "false");
		
		//Move money from one bank account to another
		Connection conn = Database.getMySQLConnection(false, connectionProperties);
		
		initValues(conn);
		
		System.out.println("\n\nVerschiebe " + transaktionsBetrag + " von '" + zuLastenId + "' zu '" + zuGunstenId + "' nicht als Transaktionen über Verbindung 1:");
		System.out.println("In Verbindung 2 werden nur die Konto-Stände gelesen!");
		update(conn);

		initValues(conn);
		
		System.out.println("\n\n\n\nVerschiebe " + transaktionsBetrag + " von '" + zuLastenId + "' zu '" + zuGunstenId + "' als eine Transaktion über Verbindung 1:");
		conn.setAutoCommit(false);
		update(conn);
		conn.setAutoCommit(true);
	}
	
	public void initValues(Connection conn){
		String sql = "UPDATE bankkonto SET saldo=? WHERE id_bankkonto=?";
		try {
			PreparedStatement statement = conn.prepareStatement(sql);
			statement.setDouble(1, zuGunstenStand);
			statement.setInt(2, zuGunstenId);
			statement.executeUpdate();
			
			statement = conn.prepareStatement(sql);
			statement.setDouble(1, zuLastenStand);
			statement.setInt(2, zuLastenId);
			statement.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	private void update(Connection conn){
		//Move money from one bank account to another
		String sql = "UPDATE bankkonto SET saldo=saldo+? WHERE id_bankkonto=?";
		
		try {
			Savepoint save = conn.setSavepoint();
			
			System.out.println("\nBevor das Geld verschoben wird:");
			printAccountsaldos(conn, zuLastenId, zuGunstenId);
			ExtendedIO.halt();
			
			PreparedStatement statement = conn.prepareStatement(sql);
			statement.setDouble(1, transaktionsBetrag * -1);
			statement.setDouble(2, zuLastenId);
			statement.executeUpdate();
			
			System.out.println("\nNachdem das Geld von '" + zuLastenId + "'abgebucht wurde:");
			printAccountsaldos(conn, zuLastenId, zuGunstenId);
			ExtendedIO.halt();
			
			statement = conn.prepareStatement(sql);
			statement.setDouble(1, transaktionsBetrag);
			statement.setDouble(2, zuGunstenId);
			statement.executeUpdate();
			
			System.out.println("\nNachdem das Geld '" + zuGunstenId + "' zugeschrieben wurde:");
			printAccountsaldos(conn, zuLastenId, zuGunstenId);
			ExtendedIO.halt();
			
			if (!conn.getAutoCommit()) {
				String selection = "";
				while (!selection.equals("Y") && !selection.equals("N")) {
					System.out.println("\nÄnderungen bestätigen? (Y/N):");
					selection = in.nextLine().toUpperCase();
				}
				
				if (selection.equals("Y")) {
					conn.commit();
					System.out.println("\nNachdem die Änderungen bestätigt wurden:");
				} else {
					conn.rollback(save); //Throws an SQL Exception if auto commit is on: you may only roll back to uncommitted changes
					System.out.println("\nNachdem die  Änderungen rückgängig gemacht wurden:");
				}
				printAccountsaldos(conn, zuLastenId, zuGunstenId);
			}
			
			conn.releaseSavepoint(save);
		} catch (SQLException | ClassNotFoundException e) {
			try {
				if (e instanceof SQLException && !conn.getAutoCommit()) {
					conn.rollback(); //in case of failure, if auto commit is off a rollback can be made
				} else {
					e.printStackTrace();
				}
			} catch(SQLException exc){
				exc.printStackTrace();
			};
		}
	}
	
	private void printAccountsaldos(Connection dbConnection, int... accountIds) throws ClassNotFoundException, SQLException{
		double summeForThisConnection = 0;
		double summeForOtherConnections = 0;
		String[][] accountInformationTable = new String[accountIds.length + 2][3];
		String header;
		if (dbConnection.getAutoCommit()) {
			header = "Text;Verbindung 1: auto commit on;Verbindung 2: Nur lesender Zugriff";
		} else {
			header = "Text;Verbindung 1: auto commit off;Verbindung 2: Nur lesender Zugriff";
		}
		accountInformationTable[0] = header.split(";");
		int i = 1;
		for (int accountId : accountIds) {
			double saldoForThisConnection = getAccountsaldo(accountId, dbConnection);
			double saldoForOtherConnections = getAccountsaldo(accountId, Database.getNewMySQLConnection(false, connectionProperties));
			summeForThisConnection += saldoForThisConnection;
			summeForOtherConnections += saldoForOtherConnections;
			accountInformationTable[i] = ("Saldo von '" + accountId + "';" + saldoForThisConnection + ";" + saldoForOtherConnections).split(";");
			i++;
		}
		accountInformationTable[i] = ("Summe;" + summeForThisConnection + ";" + summeForOtherConnections).split(";");
		System.out.println(ExtendedString.asciiFormatTable(accountInformationTable));
	}
	
	private double getAccountsaldo(int accountId, Connection dbConnection){
		try {
			String sql = "SELECT saldo FROM bankkonto WHERE id_bankkonto=?;";
			
			PreparedStatement statement = dbConnection.prepareStatement(sql);
			statement.setDouble(1, accountId);
			statement.execute();
			ResultSet rs = statement.getResultSet();
			
			while (rs.next()) { return rs.getDouble("saldo");}
			throw new SQLException("Bank Account not found");
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}

	/**
	 * This method will return as soon as the user inputs any key.
	 */
/*	private void enterToContinue() {
		System.out.println("Press enter to continue...");
		in.nextLine();
	}*/

	
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		new Main_6_Transactions();
	}

}

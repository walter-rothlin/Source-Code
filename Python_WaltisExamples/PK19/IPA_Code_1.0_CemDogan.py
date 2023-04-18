# Cem Eren Dogan
# Entwicklung einer neuen Software für Sendeproto-kolle von Star TV AG
# IPA 2023
# 1.0 Final Version
# 04.04.2023

import sys
import sqlite3
import os
from PyQt5.QtWidgets import QDialog, QApplication, QFileDialog, QMenuBar, QAction, QDesktopWidget, QScrollArea, QWidget, QTableWidget, QTableWidgetItem, QVBoxLayout, QHBoxLayout, QLabel, QLineEdit, QPushButton, QMessageBox, QFrame, QSpacerItem, QSizePolicy
from PyQt5.QtGui import QDropEvent, QIcon, QBrush
from PyQt5 import QtCore
from PyQt5.QtCore import Qt, QEvent, QUrl, QMimeData
from datetime import datetime, timedelta


class loggerCem2023(QWidget):
    def __init__(self):
        super().__init__()
        self.GUI()

        sys.stderr = LogPythonError(self)
        self.setWindowIcon(QIcon('LoggerlogoFullColor.png'))
        self.create_database()  
       

    def eventFilter(self, obj, event):
     if obj == self.upload_frame:
        if event.type() == QEvent.DragEnter:
            if event.mimeData().hasUrls():
                event.accept()
            else:
                event.ignore()
            return True
        elif event.type() == QEvent.Drop:
            self.dropEvent(event)
            return True
     return super().eventFilter(obj, event)

    
    def GUI(self):
        
        menu_bar = QMenuBar()
        logansicht_action = QAction("Logansicht", self)
        logansicht_action.triggered.connect(self.logansicht_clicked)
        menu_bar.addAction(logansicht_action)
        uber_action = QAction("Über", self)
        uber_action.triggered.connect(self.uber_clicked)
        menu_bar.addAction(uber_action)
      
        self.table = QTableWidget()
        layout = QVBoxLayout()
        layout.setMenuBar(menu_bar)
        self.setLayout(layout)
       
        self.setAcceptDrops(False)  
        self.setWindowTitle('Logger')
        self.setWindowFlags(Qt.Window)  
        self.showMaximized()

        self.initial_design()
        
    def submit_values(self):

        search_for = self.database_search_input.text()
        replace_with = self.database_replace_input.text()
       
        if search_for.strip() != '' and replace_with.strip() != '':
            conn = sqlite3.connect('search_replace.db')
            c = conn.cursor()
            c.execute('CREATE TABLE IF NOT EXISTS search_replace (id INTEGER PRIMARY KEY, search_for TEXT, replace_with TEXT)')
            c.execute('INSERT INTO search_replace (search_for, replace_with) VALUES (?, ?)', (search_for, replace_with))
            conn.commit()
            conn.close()
    
            self.database_search_input.clear()
            self.database_replace_input.clear()
            QMessageBox.information(self, 'Values Submitted', 'The search and replace values have been submitted to the database.')
            funktion = "submit_values"
            beschreibung = f"Values have been submitted ({search_for} - {replace_with})"
            self.save_log(funktion, beschreibung)
        else:
            QMessageBox.warning(self, 'Empty Values', 'Both search and replace values must be provided.')
            funktion = "submit_values"
            beschreibung = "Empty Values was tried to been submitted"
            self.save_log(funktion, beschreibung)
    
    def save_file(self):
        file_path, _ = QFileDialog.getSaveFileName(self, "Save File", "", "Text Files (*.txt)")
        
        if file_path:
            with open(file_path, 'w', encoding='utf-8') as f:
                for row in range(self.table.rowCount()):
                    row_values = []
                    for col in range(self.table.columnCount()):
                        item = self.table.item(row, col)
                        if item is not None:
                            row_values.append(item.text())
                    row_str = '\t'.join(row_values) + '\n'
                    f.write(row_str)
                    
            file_title = os.path.basename(file_path)
            funktion = "save_file"
            beschreibung = f"File saved: {file_title}, Path: {file_path}"
            self.save_log(funktion, beschreibung)       
            QMessageBox.information(self, 'File Saved', f'The table contents have been saved to {os.path.basename(file_path)}')
        else:
            pass
        
    def show_database(self):
        db_path = 'search_replace.db'
        if os.path.isfile(db_path):
            dialog = QDialog(self)
            dialog.setWindowTitle("Database Content")
            layout = QVBoxLayout(dialog)

            table = QTableWidget()
            table.setColumnCount(2)
            table.setHorizontalHeaderLabels(['Search For', 'Replace With'])
            
            conn = sqlite3.connect(db_path)
            c = conn.cursor()
            c.execute('SELECT search_for, replace_with FROM search_replace')
            values = c.fetchall()
            conn.close() 
            
            table.setRowCount(len(values))
            for i, value in enumerate(values):
                for j, val in enumerate(value):
                    item = QTableWidgetItem(str(val))
                    table.setItem(i, j, item)

            layout.addWidget(table)
            dialog.exec_()
        else:
            QMessageBox.warning(self, 'Database Not Found', 'The search_replace.db database file does not exist.')
            funktion = "show_database"
            beschreibung = "Database file does not exist."
            self.save_log(funktion, beschreibung)
        
    def refresh(self):
            file_path = self.file_path
            self.table.clear()
            
            if file_path:
                url = QUrl.fromLocalFile(file_path)
                mime_data = QMimeData()
                mime_data.setUrls([url])
                event = QDropEvent(QtCore.QPointF(), Qt.CopyAction, mime_data, Qt.LeftButton, Qt.NoModifier)
                self.dropEvent(event)
                QMessageBox.information(self, 'Refreshed', 'The table contents have been refreshed')
                
                current_item = self.layout().itemAt(1)
                if current_item is not None:
                    current_widget = current_item.widget()
                    self.layout().removeWidget(current_widget)   

                self.uploaded_design()

            else:
                QMessageBox.warning(self, 'Refresh Failed', 'The table contents could not be refreshed.')
                funktion = "refresh"
                beschreibung = "Refresh failed."
                self.save_log(funktion, beschreibung)
            

        
        
    def initial_design(self):
        self.upload_frame = QFrame(self)
        self.upload_frame.setFrameShape(QFrame.StyledPanel)
        self.upload_frame.setLineWidth(2)
        self.upload_frame.setFixedSize(200, 100)
        self.upload_frame.setAcceptDrops(True) 
        self.upload_frame.installEventFilter(self) 
    
        self.upload_label = QLabel("drag and drop a file")
        self.upload_label.setAlignment(Qt.AlignCenter)
        
        upload_layout = QVBoxLayout()
        upload_layout.addWidget(self.upload_label)
        self.upload_frame.setLayout(upload_layout)
    
        self.layout().addWidget(self.upload_frame, alignment=Qt.AlignCenter)
    
                

    def uploaded_design(self):
        
        current_widget2 = self.layout().itemAt(0).widget()
        self.layout().removeWidget(current_widget2)
        
        window_width = self.width()
        table_width = int(window_width * 0.65)
        buttons_widget_width = int(window_width * 0.35)
  
        self.table.setFixedWidth(table_width)
        table_widget = QWidget()
        table_layout = QVBoxLayout()
        title_label = QLabel("Title: " + self.file_title)
        file_path_label = QLabel("File Path: " + self.file_path)
    
        table_layout.addWidget(title_label)
        table_layout.addWidget(file_path_label)
        table_layout.addWidget(self.table)
        table_widget.setLayout(table_layout)
    
        scroll_area = QScrollArea()
        scroll_area.setWidgetResizable(True)
        scroll_area.setWidget(table_widget)
        
        buttons_layout = QVBoxLayout()
        button1_layout = QHBoxLayout()
    
        self.database_search_input = QLineEdit(self)
        self.database_search_input.setPlaceholderText("Enthält")
        self.database_search_input.setFixedWidth(260)
        self.database_search_input.setFixedHeight(40)
        button1_layout.addWidget(self.database_search_input)
    
        self.database_replace_input = QLineEdit(self)
        self.database_replace_input.setPlaceholderText("Ersetzen mit")
        self.database_replace_input.setFixedWidth(260)
        self.database_replace_input.setFixedHeight(40)
        button1_layout.addWidget(self.database_replace_input)
    
        database_submit_button = QPushButton("Submit", self)
        database_submit_button.setFixedWidth(100) 
        database_submit_button.setFixedHeight(40)  
        button1_layout.addWidget(database_submit_button)
        database_submit_button.clicked.connect(self.submit_values)
    
        buttons_layout.addLayout(button1_layout)
        left_spacer = QSpacerItem(0, 0, QSizePolicy.Expanding, QSizePolicy.Minimum)
        right_spacer = QSpacerItem(0, 0, QSizePolicy.Expanding, QSizePolicy.Minimum)
    
        show_database_button = QPushButton("Show Database", self)
        show_database_button.setFixedWidth(500)
        show_database_button.setFixedHeight(40)
        show_database_button_layout = QHBoxLayout()
        show_database_button_layout.addItem(left_spacer)
        show_database_button_layout.addWidget(show_database_button)
        show_database_button_layout.addItem(right_spacer)
        show_database_button.clicked.connect(self.show_database)
        buttons_layout.addLayout(show_database_button_layout)
    
        refresh_button = QPushButton("Refresh", self)
        refresh_button.setFixedWidth(150)  
        refresh_button.setFixedHeight(100) 
        refresh_button_layout = QHBoxLayout()
        refresh_button_layout.addItem(left_spacer)
        refresh_button_layout.addWidget(refresh_button)
        refresh_button_layout.addItem(right_spacer)
        refresh_button.clicked.connect(self.refresh)
          
        save_file_button = QPushButton("Save File", self)
        save_file_button.setFixedWidth(500)
        save_file_button.setFixedHeight(60)
        save_file_button_layout = QHBoxLayout()
        save_file_button_layout.addItem(left_spacer)
        save_file_button_layout.addWidget(save_file_button)
        save_file_button_layout.addItem(right_spacer)
        save_file_button.clicked.connect(self.save_file)

        buttons_widget = QWidget()
        buttons_widget.setLayout(buttons_layout)  
        buttons_widget.setFixedWidth(buttons_widget_width)
        buttons_layout.addLayout(show_database_button_layout)
        buttons_layout.addLayout(refresh_button_layout)
        buttons_layout.addLayout(save_file_button_layout)
    
        main_layout = QHBoxLayout()
        main_layout.addWidget(scroll_area)
        main_layout.addWidget(buttons_widget)
    
        self.layout().addLayout(main_layout)

      


            
    def dropEvent(self, event: QDropEvent):
        for url in event.mimeData().urls():
            file_path = url.toLocalFile()
            dropped_file_extension = os.path.splitext(file_path)[1]
            if file_path.endswith('.txt'):
                with open(file_path, 'r', encoding='utf-8') as f:
                    file_content = f.read()
                    rows = file_content.splitlines()
                    cols = rows[0].split('\t') if '\t' in rows[0] else rows[0].split(',')
                    
                    self.file_path = file_path
                    self.file_title = file_path.split('/')[-1]

                    self.table.setRowCount(len(rows)) 
                    self.table.setColumnCount(len(cols))
                    
                   

                    conn = sqlite3.connect('search_replace.db')
                    c = conn.cursor()
                    c.execute('CREATE TABLE IF NOT EXISTS search_replace (id INTEGER PRIMARY KEY, search_for TEXT, replace_with TEXT)')
                    c.execute('SELECT search_for, replace_with FROM search_replace')
                    search_replace = c.fetchall()
                    conn.close()
    
                    
    
                    for i, row in enumerate(rows):
                        row_items = row.split('\t') if '\t' in row else row.split(',')
                        for j, col in enumerate(row_items):
                            item = QTableWidgetItem(col)
                            self.table.setItem(i, j, item)
    
                        for search_for, replace_with in search_replace:
                            if search_for in row_items[3]:
                                row_items[3] = row_items[3].replace(row_items[3], replace_with)
                                new_row = '\t'.join(row_items) if '\t' in row else ','.join(row_items)
                                rows[i] = new_row
    
                    for i, row in enumerate(rows):
                        for j, col in enumerate(row.split('\t') if '\t' in row else row.split(',')):
                            item = QTableWidgetItem(col)
                            self.table.setItem(i, j, item)
                            
                        date_format = '%d.%m.%Y %H:%M:%S'

                    for i in range(self.table.rowCount()):
                        date_str = self.table.item(i, 1).text()
                        dt = datetime.strptime(date_str, date_format)
                        formatted_date_str = dt.strftime(date_format)
                        self.table.setItem(i, 1, QTableWidgetItem(formatted_date_str))
                    
                  
                    
                    closest_dt = None
                    min_diff = timedelta.max
                    closest_index = None
                    for i in range(self.table.rowCount()):
                        if self.table.item(i, 3).text() == "Werbeblock":
                            dt = datetime.strptime(self.table.item(i, 1).text(), date_format)
                            target_dt = dt.replace(hour=20, minute=0, second=0)
                            dt_diff = abs(dt - target_dt)
                            if dt_diff < min_diff:
                                min_diff = dt_diff
                                closest_dt = dt
                                closest_index = i
                    
                    if closest_dt is not None:
                        closest_dt_str = closest_dt.strftime(date_format)
                    
                   
                        for i in range(self.table.rowCount()):
                            if self.table.item(i, 3).text() == "Werbeblock":
                                self.table.setItem(i, 15, QTableWidgetItem(closest_dt_str))
                                
                            
                            if i == closest_index:
                                self.table.setItem(i, 6, QTableWidgetItem('20:00'))
                                
                          
                            elif self.table.item(i, 3).text() == "Single Spot":
                                self.table.setItem(i, 6, QTableWidgetItem('20:15'))
                                
                
                    red_marked_cells = 0
                    
                    for i in range(self.table.rowCount() - 1):
                        date_str_1 = self.table.item(i, 2).text()
                        date_str_2 = self.table.item(i + 1, 1).text()
                    
                        dt_1 = datetime.strptime(date_str_1, date_format)
                        dt_2 = datetime.strptime(date_str_2, date_format)
                    
                        if dt_1 != dt_2:
                            red_brush = QBrush(Qt.red)
                    
                            item_1 = self.table.item(i, 2)
                            item_1.setBackground(red_brush)
                            self.table.setItem(i, 2, item_1)
                    
                            item_2 = self.table.item(i + 1, 1)
                            item_2.setBackground(red_brush)
                            self.table.setItem(i + 1, 1, item_2)
                    
                            red_marked_cells += 2

                    if red_marked_cells > 0:
                      QMessageBox.warning(self, 'Error', 'Zeitangabe fehler!')
                      funktion = "RedMarkedCells"
                      beschreibung = f"{red_marked_cells} red marked cells found"
                      self.save_log(funktion, beschreibung)
                
                self.uploaded_design()
                event.accept()

            else:
                QMessageBox.warning(self, 'Error', 'nur text files (.txt) sind erlaubt to be dropped.')
                funktion = "dropEvent"
                beschreibung = f"Not allowed file ({dropped_file_extension}) was tried to be dropped"
                self.save_log(funktion, beschreibung)
                event.ignore()

         
    def create_database(self):
        conn = sqlite3.connect('loggersLog.db')
        c = conn.cursor()
        c.execute('''CREATE TABLE IF NOT EXISTS log_table
                     (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, funktion TEXT, beschreibung TEXT)''')
        conn.commit()
        conn.close()
    
    def save_log(self, funktion, beschreibung):
        now = datetime.now().strftime('%d.%m.%Y %H:%M:%S')
        conn = sqlite3.connect('loggersLog.db')
        c = conn.cursor()
        c.execute("INSERT INTO log_table (date, funktion, beschreibung) VALUES (?, ?, ?)", (now, funktion, beschreibung))
        conn.commit()
        conn.close()
   
        
    def logansicht_clicked(self):
        conn = sqlite3.connect('loggersLog.db')
        c = conn.cursor()
        c.execute("SELECT * FROM log_table")
        rows = c.fetchall()
    
        table = QTableWidget()
        table.setColumnCount(4)
        table.setHorizontalHeaderLabels(["ID", "Datum", "Funktion", "Beschreibung"])
        table.setRowCount(len(rows))

        for i, row in enumerate(rows):
            for j, item in enumerate(row):
                table.setItem(i, j, QTableWidgetItem(str(item)))
                
        dialog = QDialog(self)
        dialog.setWindowTitle("Logansicht")
        table.resizeColumnsToContents()
        table.resizeRowsToContents()
        layout = QVBoxLayout()
        layout.addWidget(table)
        dialog.setLayout(layout)
    
        dialog.exec_()  


    def uber_clicked(self):
        uber_dialog = QDialog(self)
        uber_dialog.setWindowTitle("Über")
        uber_layout = QVBoxLayout(uber_dialog)
        uber_label = QLabel("Created by Cem E. Dogan \n IPA 2023", uber_dialog)
        uber_label.setAlignment(Qt.AlignCenter)
        uber_layout.addWidget(uber_label)

        uber_dialog.exec_()

class LogPythonError:
    def __init__(self, app):
        self.app = app

    def write(self, text):
        if text.strip():
            funktion = "Console_Error"
            beschreibung = text.strip()
            self.app.save_log(funktion, beschreibung)
    def flush(self):
        pass


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = loggerCem2023()
    screen_size = QDesktopWidget().screenGeometry()
    screen_size.setTop(26)
    ex.setGeometry(screen_size)

    sys.exit(app.exec_())

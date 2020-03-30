# -*- coding: utf-8 -*-

from PyQt5.QtWidgets import QFileDialog, QMessageBox
from PyQt5 import QtCore, QtGui, QtWidgets
import os, sys

class Ui_MainWindow(object):

    def newWindow(self):
        os.system("python3 test.py")

    def disableButtons(self):
        if self.check_fastqc.isChecked():
            self.select_ref.setEnabled(False)
            self.cut_5.setEnabled(False)
            self.cut_3.setEnabled(False)
            self.pick_16s.setEnabled(False)
            self.pick_refseq.setEnabled(False)
        else:
            self.select_ref.setEnabled(True)
            self.cut_5.setEnabled(True)
            self.cut_3.setEnabled(True)
            self.pick_16s.setEnabled(True)
            self.pick_refseq.setEnabled(True)

    def updateCut5(self):
        global left_cut
        left_cut = str(self.cut_5.value())

    def updateCut3(self):
        global right_cut
        right_cut = str(self.cut_3.value())


    def updateThreads(self):
        global thread_num
        thread_num = str(self.threads.value())
        self.label_cut_6.setText(_translate("MainWindow", "Threads (%s)" % thread_num))

    def chooseDB(self):
        global database
        if self.pick_16s.isChecked():
            database = "kraken_silva_16s"
        elif self.pick_refseq.isChecked():
            database = "kraken_standard"

    def runSelection(self):
        try:
            global last_outdir
            global last_fastqdir
            last_outdir = output_dir
            last_fastqdir = fastq_dir
            if self.check_fastqc.isChecked():
                os.system("make raw_quality" \
                + " FASTQ_DIR=" + fastq_dir \
                + " OUTPUT_DIR=" + output_dir \
                + " THREADS=" + thread_num)
            else:
                os.system("make" \
                + " FASTQ_DIR=" + fastq_dir \
                + " TRIM_LEFT=" + left_cut \
                + " TRIM_RIGHT=" + right_cut \
                + " REF=" + ref_file[0] \
                + " OUTPUT_DIR=" + output_dir \
                + " KRAKEN_DB=" + database \
                + " THREADS=" + thread_num)
        except NameError:
            msg = QMessageBox()
            msg.setWindowTitle("Error")
            msg.setText("Please select all required files and directories!")
            msg.setIcon(QMessageBox.Critical)
            x = msg.exec_()

    def clearAll(self):
        msg = QMessageBox()
        msg.setWindowTitle("Confirm")
        msg.setText("Are you sure you want to delete all outputs from the previous run?")
        msg.setIcon(QMessageBox.Question)
        msg.setStandardButtons(QMessageBox.No | QMessageBox.Yes)
        x = msg.exec_()
        if x == QMessageBox.Yes:
            try:
                clean_this = str("make clean OUTPUT_DIR=" + last_outdir, "FASTQ_DIR=" + last_fastdir)
                os.system(clean_this)
            except NameError:
                msg2 = QMessageBox()
                msg2.setWindowTitle("Error")
                msg2.setText("No runs complete on current session.")
                msg2.setIcon(QMessageBox.Critical)
                x = msg2.exec_()

    def clearInter(self):
        msg = QMessageBox()
        msg.setWindowTitle("Confirm")
        msg.setText("Are you sure you want to delete all intermediate outputs from the previous run?")
        msg.setIcon(QMessageBox.Question)
        msg.setStandardButtons(QMessageBox.No | QMessageBox.Yes)
        x = msg.exec_()
        if x == QMessageBox.Yes:
            try:
                clean_this = str("make clean_intermediate OUTPUT_DIR=" + last_outdir)
                os.system(clean_this)
            except NameError:
                msg2 = QMessageBox()
                msg2.setWindowTitle("Error")
                msg2.setText("No runs complete on current session")
                msg2.setIcon(QMessageBox.Critical)
                x = msg2.exec_()

    def chooseFastq(self):
        global fastq_dir
        fastq_dir = str(QFileDialog.getExistingDirectory(self, "Select Directory", "./"))
        if len(fastq_dir) > 0:
            self.select_imp.setStyleSheet("background-color: green")
            self.select_imp.setText("Selected")

    def chooseRef(self):
        global ref_file
        ref_file = QFileDialog.getOpenFileName(self, "Open File", "./", "*.fasta *.fsa (*.fsa *.fasta)")
        if len(ref_file[0]) > 0:
            self.select_ref.setStyleSheet("background-color: green")
            self.select_ref.setText("Selected")

    def chooseOutput(self):
        global output_dir
        output_dir = str(QFileDialog.getExistingDirectory(self, "Select Directory", "./"))
        if len(output_dir) > 0:
            self.select_out.setStyleSheet("background-color: green")
            self.select_out.setText("Selected")

    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.setEnabled(True)
        MainWindow.resize(540, 370)
        font = QtGui.QFont()
        font.setBold(False)
        font.setWeight(50)
        font.setKerning(True)
        MainWindow.setFont(font)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.pick_16s = QtWidgets.QRadioButton(self.centralwidget)
        self.pick_16s.setGeometry(QtCore.QRect(260, 90, 100, 22))
        self.pick_16s.setObjectName("pick_16s")
        self.buttonGroup_2 = QtWidgets.QButtonGroup(MainWindow)
        self.buttonGroup_2.setObjectName("buttonGroup_2")
        self.buttonGroup_2.addButton(self.pick_16s)
        self.pick_refseq = QtWidgets.QRadioButton(self.centralwidget)
        self.pick_refseq.setGeometry(QtCore.QRect(260, 70, 121, 22))
        self.pick_refseq.setObjectName("pick_refseq")
        self.buttonGroup_2.addButton(self.pick_refseq)
        self.select_out = QtWidgets.QPushButton(self.centralwidget)
        self.select_out.setGeometry(QtCore.QRect(50, 270, 171, 40))
        self.select_out.setObjectName("select_out")
        self.select_ref = QtWidgets.QPushButton(self.centralwidget)
        self.select_ref.setGeometry(QtCore.QRect(50, 170, 171, 40))
        self.select_ref.setObjectName("select_ref")
        self.select_imp = QtWidgets.QPushButton(self.centralwidget)
        self.select_imp.setGeometry(QtCore.QRect(50, 70, 171, 40))
        self.select_imp.setObjectName("select_imp")
        self.label_imp = QtWidgets.QLabel(self.centralwidget)
        self.label_imp.setGeometry(QtCore.QRect(50, 30, 121, 21))
        font = QtGui.QFont()
        font.setPointSize(10)
        font.setBold(True)
        font.setItalic(False)
        font.setWeight(75)
        self.label_imp.setFont(font)
        self.label_imp.setObjectName("label_imp")
        self.label_ref = QtWidgets.QLabel(self.centralwidget)
        self.label_ref.setGeometry(QtCore.QRect(50, 130, 171, 21))
        font = QtGui.QFont()
        font.setPointSize(10)
        font.setBold(True)
        font.setItalic(False)
        font.setWeight(75)
        self.label_ref.setFont(font)
        self.label_ref.setObjectName("label_ref")
        self.label_out = QtWidgets.QLabel(self.centralwidget)
        self.label_out.setGeometry(QtCore.QRect(50, 230, 121, 21))
        font = QtGui.QFont()
        font.setPointSize(10)
        font.setBold(True)
        font.setItalic(False)
        font.setWeight(75)
        self.label_out.setFont(font)
        self.label_out.setObjectName("label_out")
        self.label_kraken2 = QtWidgets.QLabel(self.centralwidget)
        self.label_kraken2.setGeometry(QtCore.QRect(260, 30, 161, 21))
        font = QtGui.QFont()
        font.setBold(True)
        font.setWeight(75)
        self.label_kraken2.setFont(font)
        self.label_kraken2.setObjectName("label_kraken2")
        self.run = QtWidgets.QPushButton(self.centralwidget)
        self.run.setGeometry(QtCore.QRect(260, 250, 151, 61))
        font = QtGui.QFont()
        font.setBold(True)
        font.setWeight(75)
        self.run.setFont(font)
        self.run.setObjectName("run")
        self.cut_5 = QtWidgets.QSpinBox(self.centralwidget)
        self.cut_5.setGeometry(QtCore.QRect(260, 170, 61, 41))
        self.cut_5.setProperty("value", 15)
        self.cut_5.setObjectName("cut_5")
        self.check_fastqc = QtWidgets.QCheckBox(self.centralwidget)
        self.check_fastqc.setGeometry(QtCore.QRect(260, 220, 161, 22))
        self.check_fastqc.setObjectName("check_fastqc")
        self.label_cut_5 = QtWidgets.QLabel(self.centralwidget)
        self.label_cut_5.setGeometry(QtCore.QRect(260, 130, 51, 21))
        font = QtGui.QFont()
        font.setPointSize(10)
        font.setBold(True)
        font.setItalic(False)
        font.setWeight(75)
        self.label_cut_5.setFont(font)
        self.label_cut_5.setObjectName("label_cut_5")
        self.label_cut_3 = QtWidgets.QLabel(self.centralwidget)
        self.label_cut_3.setGeometry(QtCore.QRect(340, 130, 51, 21))
        font = QtGui.QFont()
        font.setPointSize(10)
        font.setBold(True)
        font.setItalic(False)
        font.setWeight(75)
        self.label_cut_3.setFont(font)
        self.label_cut_3.setObjectName("label_cut_3")
        self.cut_3 = QtWidgets.QSpinBox(self.centralwidget)
        self.cut_3.setGeometry(QtCore.QRect(340, 170, 61, 41))
        self.cut_3.setProperty("value", 5)
        self.cut_3.setObjectName("cut_3")
        self.threads = QtWidgets.QSlider(self.centralwidget)
        self.threads.setGeometry(QtCore.QRect(450, 60, 30, 250))
        font = QtGui.QFont()
        font.setStrikeOut(False)
        self.threads.setFont(font)
        self.threads.setAutoFillBackground(False)
        self.threads.setMaximum(20)
        self.threads.setSliderPosition(1)
        self.threads.setTracking(True)
        self.threads.setOrientation(QtCore.Qt.Vertical)
        self.threads.setInvertedAppearance(False)
        self.threads.setInvertedControls(False)
        self.threads.setTickPosition(QtWidgets.QSlider.TicksAbove)
        self.threads.setTickInterval(1)
        self.threads.setObjectName("threads")
        self.label_cut_6 = QtWidgets.QLabel(self.centralwidget)
        self.label_cut_6.setGeometry(QtCore.QRect(420, 30, 100, 21))
        font = QtGui.QFont()
        font.setPointSize(10)
        font.setBold(True)
        font.setItalic(False)
        font.setWeight(75)
        self.label_cut_6.setFont(font)
        self.label_cut_6.setObjectName("label_cut_6")
        MainWindow.setCentralWidget(self.centralwidget)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)
        self.menuBar = QtWidgets.QMenuBar(MainWindow)
        self.menuBar.setGeometry(QtCore.QRect(0, 0, 497, 23))
        self.menuBar.setObjectName("menuBar")
        self.menuFile = QtWidgets.QMenu(self.menuBar)
        self.menuFile.setObjectName("menuFile")
        MainWindow.setMenuBar(self.menuBar)
        self.actionClear_Ouputs = QtWidgets.QAction(MainWindow)
        self.actionClear_Ouputs.setObjectName("actionClear_Ouputs")
        self.actionClear_intermediate_files = QtWidgets.QAction(MainWindow)
        self.actionClear_intermediate_files.setObjectName("actionClear_intermediate_files")
        self.actionNew_Window = QtWidgets.QAction(MainWindow)
        self.actionNew_Window.setObjectName("actionNew_Window")
        self.actionNew_Window.setShortcut("Ctrl+N")
        self.menuFile.addAction(self.actionNew_Window)
        self.menuFile.addAction(self.actionClear_Ouputs)
        self.menuFile.addAction(self.actionClear_intermediate_files)
        self.menuBar.addAction(self.menuFile.menuAction())

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)
        MainWindow.setTabOrder(self.select_imp, self.select_out)
        MainWindow.setTabOrder(self.select_out, self.select_ref)
        MainWindow.setTabOrder(self.select_ref, self.pick_16s)
        MainWindow.setTabOrder(self.pick_16s, self.run)
        MainWindow.setTabOrder(self.run, self.pick_refseq)

        # Button connect
        self.pick_refseq.setChecked(True)
        self.select_out.clicked.connect(self.chooseOutput)
        self.select_ref.clicked.connect(self.chooseRef)
        self.select_imp.clicked.connect(self.chooseFastq)
        self.threads.valueChanged.connect(self.updateThreads)
        self.actionNew_Window.triggered.connect(self.newWindow)
        self.actionClear_Ouputs.triggered.connect(self.clearAll)
        self.actionClear_intermediate_files.triggered.connect(self.clearInter)
        self.cut_5.valueChanged.connect(self.updateCut5)
        self.cut_3.valueChanged.connect(self.updateCut3)
        self.check_fastqc.clicked.connect(self.disableButtons)

        # RUN
        self.run.clicked.connect(self.updateThreads)
        self.run.clicked.connect(self.chooseDB)
        self.run.clicked.connect(self.runSelection)


    def retranslateUi(self, MainWindow):
        global _translate
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "CyanoPipeline"))
        self.pick_16s.setText(_translate("MainWindow", "SILVA 16S"))
        self.pick_refseq.setText(_translate("MainWindow", "Refseq Genomic"))
        self.select_out.setText(_translate("MainWindow", "Select directory..."))
        self.select_ref.setText(_translate("MainWindow", "Select file..."))
        self.select_imp.setText(_translate("MainWindow", "Select directory..."))
        self.label_imp.setText(_translate("MainWindow", "Input reads "))
        self.label_ref.setText(_translate("MainWindow", "Reference genome "))
        self.label_out.setText(_translate("MainWindow", "Output location"))
        self.label_kraken2.setText(_translate("MainWindow", " Kraken2 database"))
        self.run.setText(_translate("MainWindow", "RUN"))
        self.label_cut_5.setText(_translate("MainWindow", "5\' Trim"))
        self.label_cut_3.setText(_translate("MainWindow", "3\' Trim"))
        self.label_cut_6.setText(_translate("MainWindow", "Threads (1)"))
        self.menuFile.setTitle(_translate("MainWindow", "File"))
        self.actionClear_Ouputs.setText(_translate("MainWindow", "Clear Ouputs"))
        self.actionClear_intermediate_files.setText(_translate("MainWindow", "Clear intermediate files"))
        self.actionNew_Window.setText(_translate("MainWindow", "New Window"))
        self.check_fastqc.setText(_translate("MainWindow", "FastQC only"))

class MainWindow(QtWidgets.QMainWindow, Ui_MainWindow):
    def __init__(self, *args, obj=None, **kwargs):
        super(MainWindow, self).__init__(*args, **kwargs)
        self.setupUi(self)

if __name__ == "__main__":

    # defaults
    thread_num = "1"
    right_cut = "15"
    left_cut = "5"

    app = QtWidgets.QApplication(sys.argv)

    window = MainWindow()
    window.show()
    app.exec()

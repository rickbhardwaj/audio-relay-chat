from Tkinter import *
import Tkinter as tki
import ttk
import random
import hashlib

class takeInput(object):
    def __init__(self,requestMessage,parent, text):        
        s = ttk.Style()
        s.theme_use('clam')

        self.string = ''
        self.frame = ttk.Frame(parent)
        self.frame.pack()        
        self.acceptInput(requestMessage)
        self.textFrame = text
        self.username = "Mr. Not Set"

        button0 = ttk.Button(self.frame, text='Set user', command=self.msg_box)
        
        button0.pack()
        

    def acceptInput(self,requestMessage):

        r = self.frame

        k = Label(r,text=requestMessage)
        k.pack(side='left')
        self.e = Entry(r,text='Name')
        self.e.pack(side='left')
        self.e.focus_set()
        b = Button(r,text='Send',command=self.gettext)
        b.pack(side='right')

    def gettext(self):
        self.string = self.e.get()

        def put(key, value):
            KVStore[key] = value
            f = open('sendBuffer.txt', 'a')
            f.write(self.string)
            f.close()
            print(KVStore)

        def get(key):
            f = open('sendBuffer.txt', 'a')
            f.write(self.string)
            f.close()
            return KVStore[key]

        def replicate(*args):
            args[0](*args[1:])

        def sanity():
            print("sanity")
    
        #Checking is valid command

        commands = {'\put': put, '\get': get, '\rep': replicate, '\san': sanity}
        KVStore = {'zero': 0}   

        parsedString = self.string.split()
        
        if parsedString[0] in commands.keys():
            commands[parsedString[0]](*parsedString[1:])
        

        #Sending to buffer
        self.textFrame.insert(INSERT, self.string)
        fromFile = "No text found"

        f = open('sendBuffer.txt', 'a')

        hs = hashlib.md5()
        hs.update(self.string)
        hashMessage = hs.hexdigest()
        count = random.randint(0, len(hashMessage))
        uniqueID = hashMessage[count:count+5]
        f.write(self.username + ": " + self.string + "#" + uniqueID + "\n")
        
        f.close()

        wholeDoc = open('recieveBuffer.txt', 'r')
        fromFile = wholeDoc.read()
        wholeDoc.close()

        self.textFrame.delete(1.0, END)
        self.textFrame.insert(INSERT, fromFile)
        #self.frame.destroy()

    def getString(self):
        return self.string

    def msg_box(self, msg='User name?', extra=True):
        top = self.top = tki.Toplevel(self.frame)
        label0 = tki.Label(top, text=msg)
        label0.pack()

        if extra:
            self.entry0 = tki.Entry(top)
            self.entry0.pack()

            button2 = tki.Button(top, text='Submit', command=self.submit_name)
            button2.pack()

        button3 = tki.Button(top, text='Cancel',
                                command=lambda: self.top.destroy())
        button3.pack()

    def submit_name(self):
        data = self.entry0.get()
        if data:
            self.username = data
            logger = open('sendBuffer.txt', 'a')
            logger.write(self.username + "has logged in\n")
            self.top.destroy()


#global lastMessage

def pollFile(filePath, lastMessage):
    f2 = open('sendBuffer.txt', 'r')
    readFirst = f2.read()
    #print "Polling File..."
    #print "Last message " + lastMessage
    #print "F2 " + readFirst
    if readFirst != lastMessage:
        lastMessage = readFirst
        f2.close()
        print True
        print "======================================="
        return True

    else:
        print False
        print "======================================="
        return False

def continuePolling(filePath, lastMessage):
    print "Eliminate method calls"
    while(True):
        
        #print "CONTINUE POLLING Last Message" + lastMessage
        if pollFile(filePath, lastMessage):
            reader = open('recieveBuffer.txt', 'r')
            lastMessage = reader.read()
        top.after(2000, top.update())

def getText(requestMessage,parent, t):
    global a
    a = takeInput(requestMessage,parent, t)
    return a.getString()

def rr(textFrame):
    commandDoc = open('commandBuffer.txt', 'r+')
    lines = commandDoc.readlines()
    commandDoc.close()
    
    wholeDoc = open('recieveBuffer.txt', 'r')
    fromFile = wholeDoc.read()
    wholeDoc.close()

    textFrame.delete(1.0, END)
    textFrame.insert(INSERT, fromFile)
    top.after(1000, rr, textFrame)

top = Tk()
text = Text(top)
f2 = open('recieveBuffer.txt', 'r')
lastMessage = f2.read()
f2.close()
#top.after(2000, continuePolling, 'sendBuffer.txt', lastMessage)
#top.after(2000, playOn)
girl = getText('Message:', top, text)
#print(girl + " has logged in") 
#text.insert(INSERT, girl)
#text.insert(INSERT, "JELLO")
text.pack()


#print "TOP MESSAGE " + lastMessage

rr(text)
top.mainloop()
#print(pollFile('sendBuffer.txt', lastMessage))

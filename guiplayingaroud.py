from Tkinter import *

class takeInput(object):

    def __init__(self,requestMessage,parent, text):

        self.string = ''
        self.frame = Frame(parent)
        self.frame.pack()        
        self.acceptInput(requestMessage)
        self.textFrame = text

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
        self.textFrame.insert(INSERT, self.string)
        f = open('sendBuffer.txt', 'a')
        f.write(self.string + "\n")
        f.close()
        #self.frame.destroy()
        print self.string

    def getString(self):
        return self.string

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
            reader = open('sendBuffer.txt', 'r')
            lastMessage = reader.read()
        top.after(2000, top.update())

def getText(requestMessage,parent, t):
    global a
    a = takeInput(requestMessage,parent, t)
    return a.getString()

top = Tk()
text = Text(top)
f2 = open('sendBuffer.txt', 'r')
lastMessage = f2.read()
f2.close()
top.after(2000, continuePolling, 'sendBuffer.txt', lastMessage) 
girl = getText('Message:', top, text)
#print(girl + " has logged in") 
#text.insert(INSERT, girl)
#text.insert(INSERT, "JELLO")
text.pack()


#print "TOP MESSAGE " + lastMessage

top.mainloop()
#print(pollFile('sendBuffer.txt', lastMessage))

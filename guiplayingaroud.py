from Tkinter import *

f2 = open('sendBuffer.txt', 'r')
lastMessage = f2.read()
def pollFile(filePath):
    if f2.read() != lastMessage:
        lastMessage = f2.read()
        return True
    return False

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

top = Tk()
text = Text(top)



def getText(requestMessage,parent, t):
    global a
    a = takeInput(requestMessage,parent, t)
    return a.getString()


girl = getText('Message:', top, text)
print(girl + " has logged in")
#text.insert(INSERT, girl)
#text.insert(INSERT, "JELLO")
text.pack()

top.mainloop()

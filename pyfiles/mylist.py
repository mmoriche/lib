def sublists(mylist,mylistdone):
   """
   Function to substract mylistdone from mylist
   The output is a list of the items of mylist that
    are not in mylistdone
   """
   # warning check
   for item in mylistdone:
     if not item in mylist:
        print 
        print ' WARNING: item '+item+' not in mylist'
        print 
   #
   mynewlist = []
   for item in mylist:
      if not item in mylistdone:
          mynewlist.append(item)
   return mynewlist


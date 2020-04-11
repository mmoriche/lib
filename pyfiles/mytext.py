import readline, rlcompleter
# SETTING FOR TAB COMPLETION WITH CRITERIAS
#def updatecompleter(mylist):
#   #
#   def complete(text, state):
#       for cmd in mylist:
#           if cmd.startswith(text):
#               if not state:
#                   return cmd
#               else:
#                   state -= 1
#   readline.parse_and_bind("tab: complete")
#   cold = readline.get_completer()
#   readline.set_completer(complete)
#

### Indenting
#class TabCompleter(rlcompleter.Completer):
#    """Completer that supports indenting"""
#    def complete(self, text, state):
#        if not text:
#            return ('    ', None)[state]
#        else:
#            return rlcompleter.Completer.complete(self, text, state)
#
#readline.set_completer(TabCompleter().complete)

def updatecompleter(mylist):
   #
   def complete(text, state):
       for cmd in mylist:
           if cmd.startswith(text):
               if not state:
                   return cmd
               else:
                   state -= 1
   #readline.parse_and_bind("tab: complete")
   ### Add autocompletion
   if 'libedit' in readline.__doc__:
       readline.parse_and_bind("bind -e")
       readline.parse_and_bind("bind '\t' rl_complete")
   else:
       readline.parse_and_bind("tab: complete")
   cold = readline.get_completer()
   readline.set_completer(complete)



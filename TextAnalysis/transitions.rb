#
# Title: transitions.rb
#
# Author: @kirai
#
# Usage: ruby transitions.rb < text.txt
#
# TODO: suggest the user on how to improve the text. "You are using too many transitions!"
#        "You are not using any time transition expression in your text" etc
#
# Description:
#  Finds transitions in your text
# 
# Info:
#  Transitions provide coherence (that hanging together, making sense as a whole) by helping the
#  reader to understand the relationship between ideas, and they act as signposts that help the
#  reader follow the movement of the discussion.
#  Also, transitions are good for "driving" the reader and making him wanting to continue reading

#Transitions data
transitions = ['however', 'in addition', 'firstly', 'secondly', 'in contrast', 'by contrast',
               'nevertheless', 'beside', 'for example', 'similarly', 'so', 'another', 'likewise',
               'apart from', 'otherwise', 'it follows', 'equally', 'at the same time', 'because',
               'afterwards', 'then', 'while', 'basically', 'essentially', 'indeed later',
               'in conclusion', 'on the other hand', 'furthermore']


transLocation = ['above', 'behind', 'by', 'near', 'throughout', 'across', 'below', 'below', 'down',
                 'across', 'below', 'down', 'off', 'to the right', 'against', 'beneath', 'in back of',
                 'onto', 'under', 'along', 'beside', 'in fornt of', 'on top of', 'among', 'between',
                 'inside', 'outside', 'around', 'beyond', 'into', 'over']

transTime = ['while', 'first', 'meanwhile', 'soon', 'then', 'after', 'second', 'today', 'later', 'next',
             'at', 'third', 'tomorrow', 'afterward', 'as soon as', 'before', 'now', 'next week', 'about',
             'when suddenly', 'during', 'until', 'yesterday', 'finally']
 
transCompareContrast = ['likewise', 'also', 'while', 'in the same way', 'like', 'as', 'similarly',
                        'but', 'still', 'although', 'on the other hand', 'however', 'yet', 'otherwise',
                        'even though'] 
 
transEmphasize = ['again', 'truly', 'especially', 'for this reason', 'to repeat', 'in fact', 'to emphasize']
 
transConcludeSummarize = ['finally', 'as a result', 'to sum up', 'in conclusion', 'lastly', 'therefore', 
                          'all in all', 'because'] 

transAddInfoClarify = ['again', 'another', 'for instance', 'for example', 'also', 'and', 'moreover',
                       'additionally', 'as well', 'besides', 'along with', 'other', 'next', 'finally', 'in addition',
                       'that is', 'for instance', 'in other words', 'specifically']


transSuggestion = [ 'for this purpose', 'to this end', 'with this in mind', 'with this purpose in mind', 'therefore']


transitions += transLocation + transLocation + transTime + transEmphasize + transConcludeSummarize + transAddInfoClarify + transSuggestion

#Read STDIN contents into text
text = ''
while line = gets
  text << line
end

#Look for the transition words
foundTransitions = {}

transitions.each do |transition| 
  if text.scan(transition).length > 0 then
    foundTransitions[transition] ||= 0
    foundTransitions[transition] += text.scan(transition).length
  end
end

p foundTransitions.sort{|a1,a2| a2[1]<=>a1[1]} #Order the hash by value

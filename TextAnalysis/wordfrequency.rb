words = File.open('freqs.txt') {|f| f.read }.split(/\s/) 
words.inject(Hash.new(0)) { |freqs, word| freqs[word] += 1; freqs }.sort_by {|x,y| y }.reverse.each {|w, f| puts w+' '+f.to_s} 

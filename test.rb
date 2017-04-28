# encoding: UTF-8

# Unit tests for the standardize_name method
# Run with: ruby test.rb

require_relative './standardize-filenames'

expected_transforms = [
  # all lower case should be unchanged
  ['author name.pdf', 'author name.pdf'],
  # title case becomes lowercase
  ['Author Some Article Name.pdf', 'author some article name.pdf'],
  # removes underscores
  ['Author_Some_Article_Name.pdf', 'author some article name.pdf'],
  # preserves hyphens
  ['Author-Lastname Compound-Word.pdf', 'author-lastname compound-word.pdf'],
  # saves acronyms
  ['Author Some Article About USAID.pdf', 'author some article about USAID.pdf'],
  # saves abbreviations for 19th century
  ['Author Some Article About 19C.pdf', 'author some article about 19C.pdf'],
  # handles French accents
  ['Author Quelques Pensées.pdf', 'author quelques pensées.pdf'],
  # handles commas
  ['Author What\'s This.pdf', 'author what\'s this.pdf']
]

s = StandardizeFilenames.new


puts "Testing #standardize_name..."

expected_transforms.each do |test|
  result = s.standardize_name test[0]
  if result == test[1]
    puts "Success: #{test[0]} => #{test[1]}"
  else
    puts "FAILURE: #{test[0]} => #{result} instead of #{test[1]}"
  end
end

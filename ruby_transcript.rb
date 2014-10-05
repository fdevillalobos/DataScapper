def string_distance(s1, s2)
  #    """ Counts the number of positions at which two strings have different
  #    characters. If the strings are of unequal length, you should count
  #    the missing characters as disagreements.
  #
  #    >>> string_distance("abc", "bca")
  #    3
  #
  #    >>> string_distance("py", "Python") # different case, different character
  #    5

  s1, s2 = s2, s1 if s2.length > s1.length
  d = s1.length - s2.length
  s2.each_char.each_with_index { |s, index| d += 1 if s != s1[index] }                                                  # Iterate through s2 and also take indexes.
  d
end

def convert_date(s)
#    """ Converts a date string of the form "mm/dd/yyyy" to a string of the
#    form "Month date, year." You should be able to handle (any number of)
#    leading zeros, but can assume the input will correspond to a valid date.
#    The month_name attribute of the calendar module may be useful:
#    https://docs.python.org/2/library/calendar.html
#
#    >>> convert_date("5/1/1998")
#    'May 1, 1998'
#
#    >>> convert_date("01/001/2000")
#    'January 1, 2000'
#    """
#parts = [x.lstrip('0') for x in s.split('/')]
#month = month_name[int(parts[0])]
#return '%s %s, %s' % (month, parts[1], parts[2])

end




def my_sort(l)
    """ Sorts a list.

    >>> my_sort([5, 2, 1, 4, 3])
    [1, 2, 3, 4, 5]

    >>> my_sort(['c', 'a', 'b'])
    ['a', 'b', 'c']
    """
# insertion sort
#for i in range(1, len(l)):
#  val = l[i]
#  j = i - 1
#  while (j >= 0) and (l[j] > val):
#    l[j+1] = l[j]
#    j = j - 1
#    l[j+1] = val
#    return l
  l.sort
end
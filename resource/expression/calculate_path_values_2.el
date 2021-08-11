$systolic:Real ::= /data[id2]/events[id3]/data[id4]/items[id5]/value/magnitude

$diastolic:Real ::= /data[id2]/events[id3]/data[id4]/items[id6]/value/magnitude

label:/data[id2]/events[id3]/data[id4]/items[id7]/value/magnitude = $systolic - $diastolic

/data[id2]/events[id3]/data[id4]/items[id8]/value/magnitude = /data[id2]/events[id3]/data[id4]/items[id7]/value/magnitude + 3

library(test)

# scenarios to test
# Truncate a long a string containing utf8 sequences
# Bad utf8
# * Overlong/short sequence
# * 5 byte technically valid sequence?
# * No intial byte
# * Only UTF-8
# * In sequence initial

if(grepl("UTF-8", Sys.getlocale(category='LC_CTYPE'))) {
  # 2 and 3 bytes
  print(trunc_utf8("#\xc3\xa7#\xe2\x99\xb1#"))
  # 2 - 4 bytes
  print(trunc_utf8("#\xc3\xa7#\xe2\x99\xb1#\xf0\x9f\x98\x80#"))
  print(trunc_utf8("#\xc3\xa7#\xe2\x99\xb1\xf0\x9f\x98\x80##"))
  # 4 bytes, alone
  print(trunc_utf8("\xf0\x9f\x98\x80"))

  # Invalid sequences
  print(trunc_utf8("\xc3\xa7\x81"))
  print(trunc_utf8("\xc3\xa7\x81#"))
  print(trunc_utf8("#\xc3\xa7\x81"))
  print(trunc_utf8("\xc3"))
  print(trunc_utf8("#\xc3"))
  print(trunc_utf8("\xc3#"))
  print(trunc_utf8("#\xa7#"))
} else if (grepl("SJIS", Sys.getlocale(category='LC_CTYPE'))) {
  # To run these start R with (or similar):
  # LC_CTYPE=ja_JP.SJIS R --no-save

  # Assorted JIS code points
  jis <- matrix(
    c(
      0x21, 0x78,  # 00A7 section 
      0x22, 0x27,  # 25BC dark triangle down
      0x26, 0x38,  # 03A9 Omega
      0x32, 0x15   # Kanji?
    ),
    2
  )
  sjis <- to_sjis(jis)

  # make a raw "phrase"

  raw <- as.raw(
    c(
      0x2d, as.integer(sjis[1,]),
      0x2d, 0xC7,
      0x2d, as.integer(sjis[2,]),
      0x2d, as.integer(sjis[3,]),
      0x2d, as.integer(sjis[4,]),
      0x2d
    )
  )
  phrase <- rawToChar(raw)
  writeLines(phrase)
  print(trunc_multi(phrase))

  # Make an invalid sequence

  raw[3] <- as.raw(0x20)
  phrase <- rawToChar(raw)
  writeLines(phrase)
  print(trunc_multi(phrase))
  raw[2:3] <- as.raw(c(0xe0, 0x2d))
  phrase <- rawToChar(raw)
  writeLines(phrase)
  print(trunc_multi(phrase))
  raw[3] <- as.raw(0x7f)
  phrase <- rawToChar(raw)
  writeLines(phrase)
  print(trunc_multi(phrase))

} else if(grepl("EUCJP", Sys.getlocale(category='LC_CTYPE'), ignore.case=TRUE)) {
  # two high bytes in 0xA1-0xFE
  # or 0x8E followe by 0xA1-0xDF for half width kana
  # or 0x8F followed by two bytes in 0xA1-0xFE

  raw <- as.raw(
    c(
      0x2d,
      c(1L, 27L) + 0xA0,        # 3007 circle (two high bytes)
      0x2d,
      0xB1, 0xB0,               # hiragana
      0x2d,
      0x8E, 0xA0 + 21L,         # halfwidth kana
      0x2d,
      0x8F, c(40L, 10L) + 0xA0, # 3 byte
      0x20, 0x2d                # weird things happen if not a space first
  ) )
  phrase <- rawToChar(raw)
  writeLines(phrase)
  print(trunc_multi(phrase))
} else {
  stop("Tests configured only for UTF8 or SJIS locales")
}



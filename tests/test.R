# Test truncation under different locales.  To use, pre-set the LC_CTYPE locale
# variable to a UTF-8 locale, SJIS, or EUCJP.  Make sure your console is also
# set to interpret those encodings as otherwise you'll see garbage even if
# everything else is working as expected..

# LC_CTYPE=ja_JP.SJIS R --no-save
# LC_CTYPE=ja_JP.eucJP R --no-save

library(test)

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
  # Assorted JIS code points.
  # Despite name, Shift JIS does not have a shift persistent state, unlike
  # "plain" JIS (2022), not tested here.

  jis <- matrix(
    c(
      0x21, 0x78,  # 00A7 section
                   # we'll add half-width katakana here
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
      0x2d, 0xC7,                    # half width katakana
      0x2d, as.integer(sjis[2,]),
      0x2d, as.integer(sjis[3,]),
      0x2d, as.integer(sjis[4,]),
      0x2d
    )
  )
  phrase <- rawToChar(raw)
  writeLines(phrase)
  print(trunc_multi(phrase))

  # Make invalid sequences.  AFAICT on OS X mbrtowc considers any of the two
  # byte sequences below to be "valid" so long as they are complete (i.e. second
  # byte is not null), without much regard to what is and is not a valid
  # encoding.  This means the string does not get truncated to before the first
  # invalid sequence.

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
      # weird things happen if not a space first after the following sequence on
      # OS-X terminal.  It appears subsequent bytes are interpreted as either
      # some continuation of strokes, or as an additional character.  iTerm does
      # not recognize the 3 byte sequences at all.
      0x8F, c(40L, 10L) + 0xA0, # 3 byte
      0x20, 0x2d
  ) )
  phrase <- rawToChar(raw)
  writeLines(phrase)
  print(trunc_multi(phrase))
} else {
  stop("Tests configured only for UTF8, SJIS, or EUCJP locales")
}



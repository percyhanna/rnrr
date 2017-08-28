# Results

## Base Point

A parsed result is represented as 6 x 5-bit pairs, for a total of 60 bits. Each character in the password is 5 bits.

For purposes of this document, a "byte" will be defined as 5 bits, and a "word" will be defined as 2 "bytes". Thus, the
password has 12 "bytes" and 6 "words".

```
_____ _____  _____ _____    _____ _____  _____ _____    _____ _____  _____ _____
```

## Legend

Each bit represents a value. Most values require more than 1 bit. The following legend is used to determine what each
bit represents.

* **`V`**: Checksum bit. Some form of hashing/checksum value to "validate" the password, to prevent simple "hacking" of
  a password.
* **`C`**: Character. Which character you are.
* **`D`**: Difficulty level.
* **`R`**: Vehicle Color.
* **`J`**: Jump/Nitro car mod.
* **`S`**: Shooter car mod.
* **`T`**: Vehicle type. (TBC)
* **`X`**: Unknown, but likely car related.
* **`?`**: Possibly a hash? A value that changed seemingly unrelated to other changes. Could be some random hash bits.

### Total Pattern

```
_____ _____  _____ _DDHH    HHTTT TOOOO  CCC__ __RRR    TTTXX XXXXX  XJJJD DDSSS
```

## Character and Difficulty

Character and Difficulty are the simplest to parse since they can be easily enumerated without any gameplay. By
enumerating over each character/difficulty combination, and comparing the differences, the following bits were
discuvered:

```
VV___ _____  ____V VDD__    _____ _____  CCC__ _____    _____ _____  _____ _____
```

## Color

```
_____ VVV__  _____ _____    _____ _____  _____ __RRR    _____ _____  _____ _____
```

## Car Mods

A fully loaded Battle Trak is: `92J!`, or `11110 10111  00110 11111`.

### Vertical/Booster

Quantity is stored in:

```
_____ _____  _____ _____    _____ _____  _____ _____    _____ _____  _JJJ_ _____
```

### Shooter

```
_____ _____  _____ _____    _____ _____  _____ _____    _____ _____  _____ __SSS
```

### Dropper

```
_____ _____  _____ _____    _____ _____  _____ _____    _____ _____  ____D DD___
```

## Money

Money is encoded as individual digits for 1s, 10s, and 100s. Each digit uses 4 bits to signify the appropriate number.

* The 6th byte appears to encode the 1s digit.
* The 5th byte appears to encode the 10s digit.
* The 5th byte appears to encode the 10s digit.

```
_____ _____  _____ ___HH    HHTTT TOOOO  _____ _____    _____ _____  ____D DD___
```

**1s**
```
1100 # 0
1101 # 1
1110 # 2
1111 # 3
1000 # 4
1001 # 5
1010 # 6
1011 # 7
0100 # 8
0101 # 9
```

**10s**
```
1010 # 0
1011 # 1
1000 # 2
1001 # 3
1110 # 4
1111 # 5
1100 # 6
1101 # 7
0010 # 8
0011 # 9
```

**100s**
```
0101 # 0
0100 # 1
0111 # 2
0110 # 3
0001 # 4
0000 # 5
0011 # 6
0010 # 7
```

## Value Lookups

### Difficulty

* **`01`**: Rookie
* **`00`**: Veteran
* **`11`**: Warrior

### Character

* **`101`**: Snake
* **`100`**: Cyberhawk
* **`111`**: Ivan
* **`110`**: Katarina
* **`001`**: Jake
* **`000`**: Tarquinn

### Vehicle Color

* **`010`**: Black
* **`011`**: Blue
* **`000`**: Red
* **`001`**: Green
* **`110`**: Yellow

### Jump/Nitro

* **`101`**: 1 (+0)
* **`110`**: 2 (+1)
* **`111`**: 3 (+2)
* **`000`**: 4 (+3)
* **`001`**: 5 (+4)
* **`010`**: 6 (+5)
* **`011`**: 7 (+6)

### Shooter

* **`001`**: 1 (+0)
* **`010`**: 2 (+1)
* **`011`**: 3 (+2)
* **`100`**: 4 (+3)
* **`101`**: 5 (+4)
* **`110`**: 6 (+5)
* **`111`**: 7 (+6) TBC

### Dropper

* **`101`**: 1 (+0)
* **`110`**: 2 (+1)
* **`111`**: 3 (+2)
* **`000`**: 4 (+3)
* **`001`**: 5 (+4)
* **`010`**: 6 (+5) TBC
* **`011`**: 7 (+6) TBC

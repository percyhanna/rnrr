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

* **`K`**: Checksum bit. Some form of hashing/checksum value to "validate" the password, to prevent simple "hacking" of
  a password.
* **`D`**: Difficulty level.
* **`H`**: Money: 100s digit.
* **`T`**: Money: 10s digit.
* **`O`**: Money: 1s digit.
* **`C`**: Character. Which character you are.
* **`B`**: Division A/B.
* **`P`**: Planet
* **`R`**: Vehicle Color.
* **`V`**: Vehicle type.
* **`A`**: Armor upgrade.
* **`K`**: Shock upgrade.
* **`I`**: Tire upgrade.
* **`E`**: Engine upgrade.
* **`J`**: Jump/Nitro quantity.
* **`M`**: Mine quantity.
* **`S`**: Shooter quantity.

**Pattern:**
```
KKKKK KKKKK  KKKKK KDDHH    HHTTT TOOOO  CCCBP PPRRR    VVVAA KKIIE  EJJJM MMSSS
```

## Hash Analysis

To validate a password, there appears to be some checksum/hashing algorithm involved.

### Bit Change Patterns

Whenever the following bits are changed, it affects a single hash bit, indicated below. It seems the first 16 bits
are checksum bits. The direct relationship between the bits changing means we're likely dealing with a simple XOR type checksum.

**Value Bits:**
```
_____ _____  _____ _0123    45678 9ABCD  EF012 34567    89ABC DEF01  23456 789AB
```

**Hash Bits:**
```
01234 56789  ABCDE F____    _____ _____  _____ _____    _____ _____  _____ _____
```

After some analysis and testing of multiple codes, it appears all value bits in the code are merely XOR'd to generate the hash bit. There is also an initial bit value of:

```
# 5-bit bytes
10000 00110  11000 0

# 8-bit bytes
1000 0001  1011 0000
```

## Difficulty

Where `DD` is one of:

* **`00`**: Veteran
* **`01`**: Rookie
* **`10`**: Unknown
* **`11`**: Warrior

## Money

Money is encoded as individual digits for 1s, 10s, and 100s. Each digit uses 4 bits to signify the appropriate number.

```
_____ _____  _____ ___HH    HHTTT TOOOO  _____ _____    _____ _____  _____ _____
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
____ # 8 Unknown
____ # 9 Unknown
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

## Character

Where `CCC` is one of:

* **`000`**: Tarquinn
* **`001`**: Jake
* **`010`**: Unknown (Olaf?)
* **`011`**: Unknown (Olaf?)
* **`100`**: Cyberhawk
* **`101`**: Snake
* **`110`**: Katarina
* **`111`**: Ivan

## Division and Planet

Where `B` is one of:

* **`0`**: Division A
* **`1`**: Division B

Where `PPP` is one of:

* **`110`**: Planet 1
* **`111`**: Planet 2
* **`100`**: Planet 3
* **`101`**: Planet 4
* **`010`**: Planet 5

`L` is an unknown value. The only pattern I've found is that it represents the last planet in the selected difficulty level. If the player is on the last planet, the value is `0`, otherwise it's `1`.

## Car Info

### Vehicle Color

* **`000`**: Red
* **`001`**: Green
* **`010`**: Black
* **`011`**: Blue
* **`100`**: Unknown
* **`101`**: Unknown
* **`110`**: Yellow
* **`111`**: Unknown

### Vehicle Type

Where `VVV` is one of:

* **`011`**: Air Blade
* **`100`**: Marauder
* **`101`**: Dirt Devil
* **`110`**: HAVAC
* **`111`**: Battle Trak

### Armor Upgrade

Where `AA` is one of:

* **`01`**: Level A
* **`00`**: Level B
* **`11`**: Level C
* **`10`**: Level D

### Shock Upgrade

Where `KK` is one of:

* **`01`**: Level A
* **`00`**: Level B
* **`11`**: Level C
* **`10`**: Level D

### Tire Upgrade

Where `II` is one of:

* **`11`**: Level A
* **`10`**: Level B
* **`01`**: Level C
* **`00`**: Level D

### Engine Upgrade

Where `EE` is one of:

* **`01`**: Level A
* **`00`**: Level B
* **`11`**: Level C
* **`10`**: Level D

### Jump/Nitro

* **`101`**: 1 (+0)
* **`110`**: 2 (+1)
* **`111`**: 3 (+2)
* **`000`**: 4 (+3)
* **`001`**: 5 (+4)
* **`010`**: 6 (+5)
* **`011`**: 7 (+6)

### Mine

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
* **`111`**: 7 (+6)

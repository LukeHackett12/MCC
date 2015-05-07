﻿<#
.SYNOPSIS
XOR-Encrypt.ps1 takes a string of text to be encrypted and a key. Each
byte of the input string will be XOR'd with a byte from the key. If 
the key is not as long as the input string, the key will repeat.
.PARAMETER String
A required parameter, the string to be encrypted.
.PARAMETER key
A required parameter, the key that the string will be XOR'd with.
.EXAMPLE
XOR-Encrypt.ps1 -String "No, I'm never going to dance again. Guilty feet have got no rhythm." -key Wham!
19074d4d687005410344210d134d4638010f0a012307410940390b044d40300908030f772f14044d2311410b44321c410540210d410a4e23480f020125001819493a46616d21
This satisifes set 1, challenge 5.
#>


[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=0)]
        [String]$String,
    [Parameter(Mandatory=$True,Position=1)]
        [String]$key
)

function ConvertHex-ToByte {
Param(
    [Parameter(Mandatory=$True,Position=0)]
        [String]$hexString
)
    $byteString = $(if ( $hexString.Length -eq 1 ) {
        ([System.Convert]::ToByte( $hexString, 16 ))
    } elseif ( $hexString.Length % 2 -eq 0 ) {
        $hexString -split "([a-fA-F0-9]{2})" | ForEach-Object {
            if ($_) {
                [System.Convert]::ToByte( $_, 16 )
            }
        }
    })

    $byteString
}

function GetBytes {
Param(
    [Parameter(Mandatory=$True,Position=0)]
        [String]$key
)
    [System.Text.Encoding]::Default.GetBytes($key)
}

$byteString = GetBytes($String)
$bytekey    = GetBytes($key)

$xordBytes = $(for ($i = 0; $i -lt $byteString.length; ) {
    for ($j = 0; $j -lt $bytekey.length; $j++) {
        $byteString[$i] -bxor $bytekey[$j]
        $i++
    }
}) 

$PaddedHex = ""
$xordBytes | ForEach-Object {
    $ByteInHex = [String]::Format("{0:X}", $_)
    $PaddedHex += $ByteInHex.PadLeft(2,"0")
}
$PaddedHex.ToLower()
<#
--- Day 4: Giant Squid ---
You're already almost 1.5km (almost a mile) below the surface of the ocean, already so deep that you can't see any sunlight. What you can see, however, is a giant squid that has attached itself to the outside of your submarine.

Maybe it wants to play bingo?

Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)

The submarine has a bingo subsystem to help passengers (currently, you and the giant squid) pass the time. It automatically generates a random order in which to draw numbers and a random set of boards (your puzzle input). For example:

7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
After the first five numbers are drawn (7, 4, 9, 5, and 11), there are no winners, but the boards are marked as follows (shown here adjacent to each other to save space):

22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
After the next six numbers are drawn (17, 23, 2, 0, 14, and 21), there are still no winners:

22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
Finally, 24 is drawn:

22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
At this point, the third board wins because it has at least one complete row or column of marked numbers (in this case, the entire top row is marked: 14 21 17 24 4).

The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.

To guarantee victory against the giant squid, figure out which board will win first. What will your final score be if you choose that board?
#>

function Get-LastWinnerScore {
    param (
        $numberSequence,
        $boards
    )
    $lastbingo = @{}
    foreach ($number in $numberSequence) {
        Set-PulledBingoNumber -number $number -boards $boards
        foreach ($board in $boards) {
            $rowMarks = 0
            $colMarks = 0
    
            for ($i=0;$i-lt 5;$i++) {
                foreach ($key in ($board.keys | Where-Object key -NotIn "Bingo")) {
                    if ($board["$key"].marked -eq $true -and $board["$key"].row -eq $i) {
                        $rowMarks++
                    }
                    if ($rowMarks -eq 5 -and $board.bingo -eq $false) {
                        $winningNumber = $number
                        $board.bingo = $true
                        $winningBoard = $board["$key"].board
                        $lastbingo = $board

                    }
    
                    if ($board["$key"].marked -eq $true -and $board["$key"].column -eq $i) {
                        $colMarks++
                    }
    
                    if ($colMarks -eq 5 -and $board.bingo -eq $false) {
                        $winningNumber = $number
                        $board.bingo = $true
                        $winningBoard = $board["$key"].board
                        $lastbingo = $board
                    }
                }
                $rowMarks = 0
                $colMarks = 0
            }
        }
    }
    
    $untaggedNumbers = ($lastbingo.Values | where marked -eq $false).Number
    $sum = 0
    $untaggedNumbers | ForEach-Object {$sum += [int] $_}
    
    [int]$winningNumber * $sum

}
function Get-FirstWinnerScore {
    param (
        $numberSequence,
        $boards
    )

    foreach ($number in $numberSequence) {
        if ($bingo) {
            break
        }
        Set-PulledBingoNumber -number $number -boards $boards
        foreach ($board in $boards) {
            if ($bingo) {
                break
            }
            $rowMarks = 0
            $colMarks = 0
    
            for ($i=0;$i-lt 5;$i++) {
                foreach ($key in $board.Keys) {
                    if ($board["$key"].marked -eq $true -and $board["$key"].row -eq $i) {
                        $rowMarks++
                    }
                    if ($rowMarks -eq 5) {
                        $winningNumber = $number
                        Write-Host "BINGO ! on Board $($board["$key"].board) in ROW $i " -ForegroundColor Green
                        $bingo = $true
                        $winningBoard = $board["$key"].board
                        break
                    }
    
                    if ($board["$key"].marked -eq $true -and $board["$key"].column -eq $i) {
                        $colMarks++
                    }
    
                    if ($colMarks -eq 5) {
                        $winningNumber = $number
                        Write-Host "BINGO ! on Board $($board["$key"].board) in Column $i " -ForegroundColor Green
                        $bingo = $true
                        $winningBoard = $board["$key"].board
                        break
                    }
                }
                $rowMarks = 0
                $colMarks = 0
            }
        }
    }
    
    $untaggedNumbers = ($boards["$winningBoard"].values | where marked -eq $false).Number
    $sum = 0
    $untaggedNumbers | ForEach-Object {$sum += [int] $_}
    
    [int]$winningNumber * $sum
    
}
function dep_Originalfunction {
    $boards = @()

for ($i = 0; $i -lt $data.Length;$i+=5) {
    $board = (New-Object 'string[,]' 5,5)
    for ($j=0;$j -lt 5;$j++) {
        $board[0,$j] = ($data[$i].Split(" "))[$j]
        $board[1,$j] = ($data[$i+1].Split(" "))[$j]
        $board[2,$j] = ($data[$i+2].Split(" "))[$j]
        $board[3,$j] = ($data[$i+3].Split(" "))[$j]
        $board[4,$j] = ($data[$i+4].Split(" "))[$j]
    }
    $boards += ,$board
    $board = $null
}

#generate marks structure
$marks = @()
foreach ($board in $boards) {
    $markboard = New-Object 'bool[,]' 5,5
    $marks += ,$markboard    
}


for ($i=0;$i -lt $boards.Length;$i++) {
    if ((Get-ValuePosInBoard -Array ($boards[$i]) -lookupValue 76)) {
        Write-Host "Found in Board $i at $(Get-ValuePosInBoard -Array ($boards[$i]) -lookupValue 76)"
    }
}


foreach ($number in $numberSequence) {
    for ($i=0;$i -le $boards.Length;$i++) {
        $foundIndex = Get-ValuePosInBoard -Array $board -lookupValue $number
        if ($foundIndex) {
            $marks[$i][$foundIndex] = $true
        }
    }
}
    
}
function Set-PulledBingoNumber {
    param (
        [string] $number,
        [object[]] $boards
    )
    
    $boardcounter = 1
    foreach ($board in $boards) {

        if ($board."$number" -ne $null -and $board.bingo -eq $false) {
            $board."$number".marked = $true
        
        }
        $boardcounter++
    }
}

function Get-InputDataHashTable {
    param (
        [string[]] $data
    )
    $counter = 0
    $boards = @()
    for ($i = 0; $i -lt $data.Length;$i+=5) {
        $board = @{ Bingo = $false}
        for ($j=0;$j -lt 5;$j++) {
            $boardNumber = $data[$i].Split(" ")[$j]
            $numberHash = @{
                Number = $boardNumber
                Row = 0
                Column = $j
                Marked = $false
                Board = $counter
            }
            $board.Add("$boardNumber",$numberHash)


            $boardNumber = $data[$i+1].Split(" ")[$j]
            $numberHash = @{
                Number = $boardNumber
                Row = 1
                Column = $j
                Marked = $false
                Board = $counter
            }
            $board.Add("$boardNumber",$numberHash)

            $boardNumber = $data[$i+2].Split(" ")[$j]
            $numberHash = @{
                Number = $boardNumber
                Row = 2
                Column = $j
                Marked = $false
                Board = $counter
            }
            $board.Add("$boardNumber",$numberHash)

            $boardNumber = $data[$i+3].Split(" ")[$j]
            $numberHash = @{
                Number = $boardNumber
                Row = 3
                Column = $j
                Marked = $false
                Board = $counter
            }
            $board.Add("$boardNumber",$numberHash)


            $boardNumber = $data[$i+4].Split(" ")[$j]
            $numberHash = @{
                Number = $boardNumber
                Row = 4
                Column = $j
                Marked = $false
                Board = $counter
            }
            $board.Add("$boardNumber",$numberHash)
        }
        $boards += $board
        $board = $null
        $counter++
    }

    $boards
}


cd D:\Coding\Github\AdventofCode2021
$data = (Get-Content ./input4.txt | select -Skip 1 | Where-Object {$_ -ne ""}).Replace("  "," ")
$data = $data.Trim()
$boards = $null

$numberSequence = (Get-Content ./input4.txt | select -First 1).Split(",")
$boards = Get-InputDataHashTable -data $data
$bingo = $false
$winningBoard = $null
$winningNumber = 0


Write-Host "First Winning Board unmarked Numbers multiplied with Winning Number is: $(Get-FirstWinnerScore -numberSequence $numberSequence -boards $boards)"
Write-Host "Last Winning Board unmarked Numbers multiplied with last Winning Number is: $(Get-LastWinnerScore -numberSequence $numberSequence -boards $boards)"

Write-Host "Script finished"
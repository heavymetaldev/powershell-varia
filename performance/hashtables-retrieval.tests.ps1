import-module pester

Describe "Hashtable retrieval" {
    $size = 1000000
    $iterations = 10000
    $splitfactor = 16
    Context "with a big ($size) hash" {
        # reserve some memory up-front
        $h = new-object -type "Hashtable" $size
        for($i = 0; $i -lt $size; $i++) {
            $h["key$i"] = "value$i"
        }
        
        It "Should retrieve $iterations random key" {
            $r = measure-command {
                for($i = 0; $i -lt $iterations; $i++) {
                    $n = Get-Random -Maximum $size
                    $val = $h["key$n"]
                }
            }
            write-host "get $iterations elements from hashtable $($h.count): $r"
        }
        
    }
    Context "with split hash ($size)" {
        $chunksize = $size / $splitfactor
        $chunks = $splitfactor
        $chunked = new-object "Hashtable[]" $chunks
        for($c = 0; $c -lt $chunks; $c++) {
            $h = new-object -type "Hashtable" $chunksize
            $chunked[$c] = $h
        }
        for($i = 0; $i -lt $size; $i++) {
            $key = "key$i"
            $val = "value$i"
            $c = $key.GetHashCode() % $chunks
            $chunked[$c][$key] = $val
        }
        
        It "Should retrieve $iterations random key" {
            $r = measure-command {
                for($i = 0; $i -lt $iterations; $i++) {
                    $n = Get-Random -Maximum $size
                    $key = "key$n"
                    $c = $key.GetHashCode() % $chunks
                    $val = $chunked[$c][$key]
                    
                }
            }
            write-host "get $iterations elements from split hashtable: $r"
        }
        
    }
}

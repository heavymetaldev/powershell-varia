import-module pester

Describe "Hashtable adding" {
    $size = 1000000
    $splitfactor = 16
    Context "with a big ($size) hash" {
        # reserve some memory up-front
        $h = new-object -type "Hashtable" $size
          
        It "Should create by merging hashtables" {
            $h = @{
            }
            $r = measure-command {
                for($i = 0; $i -lt $size; $i++) {
                    $h += @{ "key$i" = "value$i" }
                }
            }
            write-host "create by merging $($h.count) items: $r"
        }
        
        It "Should be even faster when predefining size" {
            $h = new-object -type "Hashtable" $size
            $r = measure-command {
                for($i = 0; $i -lt $size; $i++) {
                    $h["key$i"] = "value$i"
                }
            }
            write-host "create by setting $($h.count) items with predefined size: $r"
        }
        It "Should be faster if using one hashtable" {
            $h = @{
            }
            $r = measure-command {
                for($i = 0; $i -lt $size; $i++) {
                    $h["key$i"] = "value$i"
                }
            }
            write-host "create by setting $($h.count) items: $r"
        }
        It "should create hashtable split into $splitfactor" {
            $r = measure-command {    
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
            }
            write-host "create $splitfactor split hastables for $($h.count) items: $r"
        }
        
    }
}

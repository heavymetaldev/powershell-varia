import-module pester

Describe "Hashtable enumeration" {
    $size = 1000
    Context "with a big ($size) hash" {
        $h = @{
        }
        for($i = 0; $i -lt $size; $i++) {
            $h += @{ "key$i" = "value$i"  }
        }
        It "Should enumerate hashtable with enumerator" {
            $r = measure-command {
                foreach ($e in $h.GetEnumerator()) {
                    $k = $e.key
                    $v = $e.value
                }
            }
            write-host "enumerating $($h.count) items by enumerator: $r"
        }
        It "Should enumerate hashtable with keys collection" {
            $r = measure-command {
                foreach ($k in $h.keys) {
                    $v = $h[$k]
                }
            }
            write-host "enumerating $($h.count) items by keys: $r"
        }
         It "Should enumerate hashtable with keys collection and alternative retrieval" {
            $r = measure-command {
                foreach ($k in $h.keys) {
                    $v = $h.$k
                }
            }
            write-host "enumerating $($h.count) items by enumerator: $r"
        }
    }
}

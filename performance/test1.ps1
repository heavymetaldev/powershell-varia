 $size = 10000
    $h = @{
    }
    for($i = 0; $i -lt $size; $i++) {
        $h += @{ "key$i" = "value$i"  }
    }
    $r = measure-command {
        foreach ($e in $h.GetEnumerator()) {
            $k = $e.key
            $v = $e.value
        }
    }
    write-host "enumerating $($h.count) items by enumerator: $r"

    $r = measure-command {
        foreach ($k in $h.keys) {
            $v = $h[$k]
        }
    }
    write-host "enumerating $($h.count) items by keys: $r"
        
    $r = measure-command {
        foreach ($k in $h.keys) {
            $v = $h.$k
        }
    }
    write-host "enumerating $($h.count) items by keys with property accessor: $r"

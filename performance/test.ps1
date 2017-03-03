$size = 10000
$h = @{
}
for($i = 0; $i -lt $size; $i++) {
    $h += @{ "key$i" = "value$i"  }
}
measure-function "enumerating $($h.count) items by enumerator" {
    foreach ($e in $h.GetEnumerator()) {
        $k = $e.key
        $v = $e.value
    }
}

measure-function "enumerating $($h.count) items by keys" {
    foreach ($k in $h.keys) {
        $v = $h[$k]
    }
}
measure-function "enumerating $($h.count) items with property accessor" {
    foreach ($k in $h.keys) {
        $v = $h.$k
    }
}

$global:perfcounters | format-table -AutoSize -Wrap | out-string | write-host
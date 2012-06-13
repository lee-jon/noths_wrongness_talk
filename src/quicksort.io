List do(
    quickSort := method(
        if(size > 1) then(
            pivot := at(size / 2 floor)
            return select(x, x < pivot) quickSort appendSeq(
                select(x, x == pivot) appendSeq(select(x, x > pivot) quickSort)
            )
        ) else(return self)
    )
 
    quickSortInPlace := method(
        copy(quickSort)
    )
)

+++
title = "Challenge #1: Modify a table data"
date = "2020-05-02"
+++

### Given the next structure that represents a data table

```python
[
 [foo:42, baz:7],
 [foo:45, bar:8, baz:9],
]
```

N rows, M items in a row, an item is `<label>:<value>`

Return a new structure with null values for items with no label e.g. constant row length.

```python
[
    [foo:42, bar:7, baz:null],
    [foo:45, bar:8, baz:9],
]
```

labels can arbitrary repeat e.g.:

```python
[
    [foo:42, foo:99, bar:7, foo:77],
    [foo:45, baz:9, baz:9, bar:8, baz:9, baz:10],
]
```

the consequence of labels in output can arbitrary.

### Limitations

N < 10^6, M < 10^6

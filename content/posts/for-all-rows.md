+++
title = "Challenge #1: Modify a table data"
date = "2020-05-02"
description = "Python coding challenge: normalize table row lengths by filling missing labels with null values."
tags = ["python", "coding-challenge"]
+++

> 🧩 Challenge: Normalize table row lengths
> 🐍 Language: Python

## 📋 Problem

Given a structure that represents a data table:

```python
[
 [foo:42, baz:7],
 [foo:45, bar:8, baz:9],
]
```

N rows, M items in a row, an item is `<label>:<value>`

Return a new structure with null values for items with no label — ensuring constant row length.

## ✅ Expected Output

```python
[
    [foo:42, bar:7, baz:null],
    [foo:45, bar:8, baz:9],
]
```

## 🔁 Edge Case: Repeating Labels

Labels can repeat arbitrarily:

```python
[
    [foo:42, foo:99, bar:7, foo:77],
    [foo:45, baz:9, baz:9, bar:8, baz:9, baz:10],
]
```

The order of labels in the output can be arbitrary.

## ⚠️ Limitations

N < 10^6, M < 10^6

# Data Description and Preprocessing Steps

This document explains the structure of the battery degradation data and the Python code used to preprocess it into a usable tabular format (`pandas.DataFrame`).

---

## 1. Data Structure Overview (from original `.mat` files)

The raw data is stored in MATLAB’s `.mat` binary format and exhibits a hierarchical, nested structure, akin to folders within folders:

### **Layer 1: Cells**
The highest level contains individual battery cells, typically named:
- `Cell1`, `Cell2`, ..., `Cell8`

### **Layer 2: Characterisation Cycles**
Within each cell, data is organized by the cycle number at which characterisation tests were performed:
- e.g., `cyc0000` (initial), `cyc0100` (after 100 cycles), ..., `cyc8200`

### **Layer 3: Test Modes**
Inside each cycle, there are different types of characterisation tests:
- `C1ch`: 1C (Constant Current) Charge  
- `C1dc`: 1C (Constant Current) Discharge  
- `OCVch`: Pseudo-Open Circuit Voltage Charge  
- `OCVdc`: Pseudo-Open Circuit Voltage Discharge

### **Layer 4: Raw Measurements**
Each test mode contains actual time-series measurements:
- `t`: time (in seconds)  
- `v`: voltage (in Volts)  
- `q`: charge (in mAh)  
- `T`: temperature (in degrees Celsius)

This deeply nested structure, combined with how `scipy.io.loadmat` handles MATLAB structs (often as NumPy arrays of dtype `'O'`), results in multiple layers of wrappers like `[[value]]` and `numpy.void` objects that must be unwrapped.

---

## 2. Preprocessing Steps (Python Code Logic)

The provided Python code (`get_data` and its helpers) recursively flattens and transforms the nested data structure into a clean `pandas.DataFrame`.

### **Core Logic**

#### `flatten(data)`
A recursive helper that unwraps nested `numpy.ndarray` objects containing singleton values. It recursively flattens arrays until it reaches the actual data (or a NumPy struct).

#### `get_data(data)`
The main recursive function:

- **Initial Flattening**  
  Calls `flatten(data)` to remove wrapper arrays.

- **Layer Detection & Recursion**
  It inspects the keys of the current layer to determine how to proceed:

  - **Layer 4: Raw Measurements**  
    If `'t'` is present:  
    Extracts `t`, `v`, `q`, and `T` arrays and returns a DataFrame.

  - **Layer 3: Test Modes**  
    If `'C1ch'` is present:  
    Iterates through test modes (`C1ch`, `C1dc`, etc.), recursively calls `get_data()`, adds a `"Mode"` column, and concatenates the resulting DataFrames.

  - **Layer 2: Characterisation Cycles**  
    If `'cyc0000'` is present:  
    Iterates through characterisation cycles (`cyc0000`, `cyc0100`, ...), recursively calls `get_data()`, adds a `"Cycle"` column, and concatenates the resulting DataFrames.

  - **Fail-safe**  
    If no expected keys are found, the function assumes the structure is unexpected or it has reached an endpoint.

### **Main Data Processing Loop**

- Iterates over the top-level `Cell` keys in the loaded `.mat` data.
- For each cell:
  - Calls `get_data(data[key])`
  - Adds a `"Cell"` column to indicate which cell the data came from.
  - Appends the resulting DataFrame to `data_lst`.
- Combines all results into a single DataFrame:
  ```python
  data_df = pd.concat(data_lst)


## Citation

**PhD Thesis**  
Christoph R. Birkl, *Diagnosis and Prognosis of Degradation in Lithium-Ion Batteries*, PhD thesis, Department of Engineering Science, University of Oxford, 2017.

**Related Papers**  
[https://scholar.google.co.uk/citations?hl=en&user=AZdBXIkAAAAJ&view_op=list_works&sortby=pubdate](https://scholar.google.co.uk/citations?hl=en&user=AZdBXIkAAAAJ&view_op=list_works&sortby=pubdate)

use fast2s;
use pyo3::prelude::*;

/// Formats the sum of two numbers as string.
#[pyfunction]
fn to_simplified(traditional: &str) -> PyResult<String> {
    Ok(fast2s::convert(traditional))
}

/// A Python module implemented in Rust.
#[pymodule]
fn hbl(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(to_simplified, m)?)?;
    Ok(())
}

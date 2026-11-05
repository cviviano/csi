<img width="1254" height="1254" alt="CSI_logo" src="https://github.com/user-attachments/assets/d29badd7-4266-40f0-a0b5-40a502439604" />
# CSI: CRISM Spectral Interrogator

CSI (CRISM Spectral Interrogator) is an IDL-based graphical tool for efficient, reproducible analysis of Compact Reconnaissance Imaging Spectrometer for Mars (CRISM) data. CSI brings image visualization, region-of-interest (ROI) selection, spectral extraction and ratioing, comparison with reference spectra, interpretation, and documentation into a single workflow.

CSI was developed to reduce the effort required to document CRISM spectral analyses while preserving information needed to reproduce an extraction, including the source image, numerator and denominator locations, and ROI dimensions.

**Authors:** Christina E. Viviano and Frank P. Seelos  
**Software DOI:** https://doi.org/10.5281/zenodo.21892952  
**Repository:** https://github.com/cviviano/csi  
**Documentation:** https://github.com/cviviano/csi/wiki

## Key Features

- Interactive display of CRISM parameter and browse products.
- Support for CRISM products spanning VNIR, IR, and joined wavelength ranges and multiple spectral sampling modes.
- Automated handling and joining of compatible S- and L-detector products.
- Interactive numerator and denominator ROI definition, extraction, and spectral ratioing.
- Display of numerator, denominator, and ratioed spectra for quality control and interpretation.
- Comparison with MICA CRISM type spectra and laboratory reference spectra.
- Recording of dominant and secondary spectral contributors, mineralogical interpretations, morphology, ROI geometry, and geographic location.
- Saving and restoring CSI analysis tables.
- CSV output designed for use in JMARS and import into GIS software such as ArcGIS Pro and QGIS.

## System Requirements

CSI requires **IDL 8.x or later** and is designed to operate without ENVI. It is intended for IDL-supported Windows, macOS, and Linux systems. At least 8 GB of RAM is recommended; 16 GB or more is preferable when working with large hyperspectral products. Sufficient local disk space is required for CRISM products and associated ancillary and spectral-library data.

## Installation

Clone the repository:

```bash
git clone https://github.com/cviviano/csi.git
cd csi
```

Add the top-level CSI repository to the IDL search path if necessary. For example:

```idl
!PATH = EXPAND_PATH('+<path-to-csi>') + PATH_SEP(/SEARCH_PATH) + !PATH
```

The repository can alternatively be added permanently through the IDL preferences or the `IDL_PATH` environment variable.

## Getting Started

Start IDL and launch CSI with:

```idl
CSI
```

Optionally specify the initial directory containing CRISM data products:

```idl
CSI, DIRECTORY='/path/to/crism/data/'
```

The CSI installation location is used to locate the bundled source code, wavelength tables, spectral libraries, and other ancillary resources; `DIRECTORY` identifies the user's CRISM data location.

Detailed instructions and analysis guidance are available in the [CSI Wiki](https://github.com/cviviano/csi/wiki).

## Input Data

CSI is designed for processed CRISM I/F products and their associated parameter, browse, geometric/DDR, header, and wavelength information. Input products should retain standard CRISM/PDS naming conventions because CSI uses filenames and directory relationships to identify associated products.

Typical inputs include corrected S- or L-detector TRR3 products and joined/map-projected products, for example:

```text
frt0000XXXX_07_if165_s_trr3_CAT_corr.img
frt0000XXXX_07_if165_l_trr3_CAT_corr.img
frt0000XXXX_07_if165_j_ter3.img
```

Keep the associated CRISM products and headers in the expected directory structure and avoid renaming products that CSI must discover automatically. See the Wiki for current file-selection requirements and supported product configurations.

## Basic Analysis Workflow

### Select and Display CRISM Products

Load the CRISM observation and inspect the available parameter and browse products to identify regions with spectral variability or candidate mineral signatures.

### Define Numerator and Denominator ROIs

Define a numerator ROI over the material of interest and a denominator ROI over nearby spectrally bland material. When possible, keep the denominator in the **same detector column** as the numerator to minimize cross-track instrumental differences. If no suitable bland material is available in that column, spectral blandness should take priority.

Always inspect the unratioed numerator and denominator spectra in addition to the ratio. An absorption in the denominator is inverted by division and can introduce an artificial feature into the ratioed spectrum. For example, using an LCP-bearing denominator when evaluating plagioclase can distort the spectral shape near the broad ~1.3-micron plagioclase feature.

### 1-micron Offset Correction

Joined VNIR-IR CRISM spectra can retain a small discontinuity near the detector boundary because of the decreasing spectral response toward the longest wavelengths of the VNIR detector. CSI provides an offset-correction option to improve continuity across this join. The correction is intended to mitigate a detector artifact rather than alter genuine mineral absorptions; compare corrected and uncorrected spectra when interpreting features near 1 micron.

### Compare Reference Spectra

Compare extracted CRISM spectra with both **MICA type spectra** and corresponding **laboratory reference spectra**. Evaluate the positions, shapes, widths, and relative strengths of diagnostic absorptions rather than relying only on overall visual similarity. MICA spectra provide examples observed under actual CRISM conditions, whereas laboratory spectra provide complementary examples of expected mineral spectral behavior.

Natural spectra need not exactly reproduce laboratory spectra. Composition, grain size, abundance, mixtures, and observational conditions can modify absorption positions and strengths.

### Dominant and Secondary Spectral Contributors

If more than one phase contributes to an extracted spectrum, designate the **spectrally dominant phase** and, where appropriate, a **secondary phase**. CSI assigns the dominant phase color to the ROI **fill** and the secondary phase color to its **outline**, providing a compact visual representation of the interpretation in the CSI table and exported products.

### Extract Locations

After defining the ROIs and reviewing the spectra, use **Extract** to add the location to the CSI table. CSI records the ROI and associated spectral, mineralogical, morphological, geographic, and display information.

### Restore Locations

Previously saved locations can be restored with **File > Restore table...**. Select the desired CSI table file to repopulate the saved locations and continue an earlier analysis.

### Delete Locations

Select the corresponding row in the CSI table and choose **Delete Selected Row**. The location is removed and the remaining entries are renumbered. Save the table afterward to preserve the change.

## Saving Results

Use **File > Save table** or **File > Save table as...** to save the CSI table. Preserve the filename convention suggested by CSI so the analysis remains readily associated with its source CRISM observation. CSI saves the output table in the directory containing the input image.

## Using CSI Results in Other Applications

### JMARS

CSI CSV output can be imported into **JMARS** as a custom shape layer. Identify the CSI longitude and latitude fields as the spatial coordinates. CSI writes its fill and line colors in the format expected by JMARS, so the symbology is applied automatically on import: the fill represents the spectrally dominant phase and the outline represents the secondary phase.

### ArcGIS Pro

Add the CSI CSV to **ArcGIS Pro** and use **XY Table To Point**, assigning longitude as X and latitude as Y. Select the appropriate Mars geographic coordinate system. CSI fill and line colors are retained as attributes and can be used to reproduce the CSI symbology, but ArcGIS Pro does not automatically interpret these fields as feature symbology.

### QGIS

In **QGIS**, use **Add Delimited Text Layer**, assigning longitude as X and latitude as Y and selecting the appropriate Mars coordinate reference system. CSI fill and line colors remain available as attributes and can be used to reproduce the dominant-phase fill and secondary-phase outline convention.

## Documentation

The [CSI GitHub Wiki](https://github.com/cviviano/csi/wiki) contains detailed guidance on installation, input products, image and parameter interpretation, ROI selection and ratioing, spectral comparison, and exporting results.

## Citation

If you use CSI in research, please cite the archived software release:

> Viviano, C. E., & Seelos, F. P. (2026). *CSI: CRISM Spectral Interrogator* (Version 1.0.0) [Software]. Zenodo. https://doi.org/10.5281/zenodo.21892952

Citation metadata are also provided in [`CITATION.cff`](CITATION.cff). GitHub will use this file to provide a **Cite this repository** option.

For scientific interpretation of the CRISM summary products and MICA spectral library, users should also consult:

> Viviano, C. E., et al. (2014). Revised CRISM spectral parameters and summary products based on the currently detected mineral diversity on Mars. *Journal of Geophysical Research: Planets, 119*, 1403-1431. https://doi.org/10.1002/2014JE004627

Users should additionally cite the appropriate CRISM instrument, data products, and external spectral libraries used in their analyses.

## Funding and Acknowledgments

Development of CSI was supported by the **NASA Planetary Science Division, Planetary Data Archiving and Tools (PDART) Program**, Award **80NSSC21K0883**.

CSI was developed to support reproducible CRISM spectral analysis and community use of the CRISM archive.

## License

See the repository `LICENSE` file for the terms governing use and redistribution of CSI.

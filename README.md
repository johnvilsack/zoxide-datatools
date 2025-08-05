# zoxide-datatools

Command-line tools for managing your [zoxide](https://github.com/ajeetdsouza/zoxide) database. 

## Features

- **Export Your Data**: Save your zoxide data in csv or other formats for portability or backup use.

- **Bulk Editing**: Manage your data the way you want. Create and delete entries as you see fit.
 
- **Modify Scoring**: Set frecency scores to levels you decide.
 
- **Backup/Restore**: Versioned database backups with safe restore functionality on failed imports

- **Flexible Processing**: Merge or replace.

## Quick Start

### Main Workflow
```bash
# 1. Export your zoxide data to CSV for editing
./zoxide-datatools.sh export

# 2. Edit zoxide-data.csv in Excel, Google Sheets, Numbers, etc.
# 3. Import your changes back
./zoxide-datatools.sh import
```

### All Commands

#### Primary Commands
```bash
# Export zoxide database to CSV for editing
./zoxide-datatools.sh export [--simple|--keep-uri|--sort] [filename]

# Import edited CSV back to zoxide
./zoxide-datatools.sh import [--merge|--replace] [--dry-run] [filename]

# Database backup and restore
./zoxide-datatools.sh backup                    # Create backup
./zoxide-datatools.sh restore                   # Restore from backup
```

#### Advanced Commands (Power Users)
```bash
# Direct format conversions
./zoxide-datatools.sh getzoxide    output.txt [keywords...]     # Export raw data
./zoxide-datatools.sh tosimplecsv  input.txt output.csv         # Convert to simple CSV
./zoxide-datatools.sh tocsv        input.txt output.csv         # Convert to full CSV
./zoxide-datatools.sh totext       input.csv output.txt         # CSV to zoxide format
./zoxide-datatools.sh toz          input.txt output.z           # Convert to z-shell format
./zoxide-datatools.sh sort         input.txt output.txt         # Sort hierarchically

# Advanced import (any format)
./zoxide-datatools.sh import-file [--dry-run] [--merge|--replace] filename
```

## File Formats

### Zoxide Native Format (`.txt`) - Sorts by score
```
5.0	/Users/foo/.local/zoxide
12.5	/Users/foo/.local
26.0	/Users/foo
```

### Zoxide Native Format (`.txt`) - Hierarchical sort
```
26.0	/Users/foo
12.5	/Users/foo/.local
5.0	/Users/foo/.local/zoxide
```

### Simple CSV Format (`.csv`) - **Most Popular**
```csv
"5.0","/Users/foo/.local/zoxide"
"12.5","/Users/foo/.local"
"26.0","/Users/foo"
```

### Full CSV Format (`.csv`) - **Advanced**
```csv
"5.0","Users","foo",".local","zoxide"
"12.5","Users","foo",".local"
"104.0","Users","foo"
```

### Z-Shell Format (`.z`)
```
/Users/foo/.local/zoxide|20|1
/Users/foo/.local|50|1
/Users/foo|64|1
```

## Usage Examples

### Basic Workflow
```bash
# Export your zoxide database for editing
./zoxide-datatools.sh export
# Creates zoxide-data.csv with full path information

# Edit zoxide-data.csv in your favorite spreadsheet app
# - Adjust scores
# - Remove unwanted paths  
# - Add new paths

# Import your changes back
./zoxide-datatools.sh import
# Automatically detects format and safely imports
```

### Export Options
```bash
# Export with simple format (just score and path)
./zoxide-datatools.sh export --simple

# Export to custom filename
./zoxide-datatools.sh export my-zoxide-data.csv

# Export simple format to custom file
./zoxide-datatools.sh export --simple simple-data.csv
```

### Import Options  
```bash
# Preview changes before importing
./zoxide-datatools.sh import --dry-run

# Replace entire database (removes paths not in file)
./zoxide-datatools.sh import --replace

# Import from custom file
./zoxide-datatools.sh import my-data.csv

# Import with specific mode
./zoxide-datatools.sh import --merge --dry-run custom.csv
```

### Safety Features
```bash
# Manual backup before major changes
./zoxide-datatools.sh backup

# Preview what will change
./zoxide-datatools.sh import --dry-run my-data.csv

# If something goes wrong, restore easily
./zoxide-datatools.sh restore
```

### Advanced: Filter Exports
```bash
# Export only paths containing "project" (uses advanced commands)
./zoxide-datatools.sh getzoxide project-paths.txt project
./zoxide-datatools.sh export project-data.csv
```

## Import System

### Supported Formats
The import system automatically detects and handles:

- **Full CSV**: `"score","/path","seg1","seg2",...` (exported by `export` command)
- **Simple CSV**: `"score","/path"` (exported by `export --simple` command)
- **Autojump format**: `score<TAB>path` (native zoxide export format)
- **Z format**: `path|score|timestamp` (z-shell compatibility)

### Import Modes
- **`--merge`** (default): Add/update entries, keep existing data
- **`--replace`**: Replace entire database with import data
- **`--dry-run`**: Preview changes without modifying database

### Safety Features
- **Automatic backups** before every import
- **Format validation** with helpful error messages
- **Auto-rollback** if import fails
- **Preview mode** to see changes before applying

## Backup System

The backup system automatically preserves existing backups:

- `db.zo.backup` - Most recent backup
- `db.zo.backup.20240804_143022` - Previous backups with timestamps  
- `db.zo.backup.20240803_091500` - Older backups preserved

Backups are stored in `$_ZO_DATA_DIR` (defaults to `~/.local/share/zoxide`).

## Technical Details

### Score Conversion
- **Simple CSV/Native**: Preserves original floating-point scores
- **Z-format**: Multiplies scores by 4 and converts to integers (zoxide compatibility requirement)
- **Import handling**: Z format clears database first to prevent score doubling

### Path Handling  
- **Simple CSV**: Just score and full path (most user-friendly)
- **Full CSV mode**: Splits paths into directory segments for advanced spreadsheet manipulation
- **URI preservation**: `--keep-uri` flag maintains full paths alongside segments
- **Hierarchical sorting**: Orders entries by directory depth, then alphabetically

### Environment Variables
- `$_ZO_DATA_DIR`: Zoxide data directory (default: `~/.local/share/zoxide`)

## Testing

Run the comprehensive test suite:
```bash
# Test with default script
./zoxide-datatools-tests.sh

# Test with specific script version
./zoxide-datatools-tests.sh zoxide-datatools-backup.sh
```

## Requirements

- Bash 4.0+
- [zoxide](https://github.com/ajeetdsouza/zoxide) installed and configured
- Standard Unix utilities (awk, sort, date)

## Installation

1. Clone or download `zoxide-datatools.sh`
2. Make executable: `chmod +x zoxide-datatools.sh`  
3. Test it works: `./zoxide-datatools.sh export --help`

## Getting Started

```bash
# Your first export/import cycle
./zoxide-datatools.sh export           # Creates zoxide-data.csv
# Edit the CSV file in your favorite spreadsheet app
./zoxide-datatools.sh import           # Imports your changes

# View all available commands
./zoxide-datatools.sh --help
```

## License

This tool is designed to work with zoxide. See [zoxide's license](https://github.com/ajeetdsouza/zoxide/blob/main/LICENSE) for details.

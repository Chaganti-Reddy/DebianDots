#!/bin/bash

# Temporary Python script path
SCRIPT_PATH="$(mktemp /tmp/download_script_XXXX.py)"

# Embed Python code into the script
cat << 'EOF' > "$SCRIPT_PATH"
import os
import requests
import feedparser
from pathlib import Path
from urllib.parse import quote

# Constants
MAX_RESULTS = 5
REQUEST_TIMEOUT = 15
DOWNLOADS_DIR = os.path.expanduser("~/Downloads")

# Ensure Downloads directory exists
os.makedirs(DOWNLOADS_DIR, exist_ok=True)

def sanitize_filename(title):
    """Clean filenames for safe saving"""
    keepchars = (' ', '.', '_', '-')
    return "".join(c for c in title if c.isalnum() or c in keepchars).rstrip()

def get_download_path(filename):
    """Get path to Downloads directory"""
    return os.path.join(DOWNLOADS_DIR, filename)

def download_file(url, path):
    """Generic file download"""
    try:
        response = requests.get(url, timeout=REQUEST_TIMEOUT)
        if response.status_code == 200:
            with open(path, 'wb') as f:
                f.write(response.content)
            return True
        return False
    except Exception as e:
        print(f"Download error: {str(e)}")
        return False

def handle_download(content_url, filename):
    """Download the file to ~/Downloads"""
    path = get_download_path(filename)
    print(f"\nDownloading to {path}...")
    return download_file(content_url, path)

def search_gutenberg(query):
    """Search Project Gutenberg"""
    try:
        url = f"https://gutendex.com/books?search={quote(query)}"
        response = requests.get(url, timeout=REQUEST_TIMEOUT)
        results = []
        
        for book in response.json().get('results', []):
            valid_formats = {
                k: v for k, v in book.get('formats', {}).items()
                if any(ext in k for ext in ['txt', 'pdf', 'epub', 'html'])
            }
            if valid_formats:
                results.append({
                    'title': book.get('title', 'Untitled').strip(),
                    'author': ', '.join([a['name'] for a in book.get('authors', [])]),
                    'source': 'Project Gutenberg',
                    'formats': valid_formats
                })
        return results[:MAX_RESULTS]
    except Exception as e:
        print(f"Gutenberg error: {str(e)}")
        return []

def search_arxiv(query):
    """Search arXiv for papers"""
    try:
        url = f"http://export.arxiv.org/api/query?search_query=all:{quote(query)}&start=0&max_results={MAX_RESULTS}"
        response = requests.get(url, timeout=REQUEST_TIMEOUT)
        feed = feedparser.parse(response.content)
        
        return [{
            'title': entry.title.strip(),
            'author': ', '.join(a.name for a in entry.authors),
            'source': 'arXiv',
            'pdf_url': next((link.href for link in entry.links if link.type == 'application/pdf'), None)
        } for entry in feed.entries if entry.get('links')][:MAX_RESULTS]
    except Exception as e:
        print(f"arXiv error: {str(e)}")
        return []

def search_internet_archive(query):
    """Search Internet Archive"""
    try:
        url = f"https://archive.org/advancedsearch.php?q={quote(query)}&output=json&fl[]=identifier,title,creator,format"
        response = requests.get(url, timeout=REQUEST_TIMEOUT)
        data = response.json()
        
        results = []
        for item in data.get('response', {}).get('docs', []):
            if 'Text PDF' in item.get('format', []):
                results.append({
                    'title': item.get('title', 'Untitled').strip(),
                    'author': item.get('creator', 'Unknown'),
                    'source': 'Internet Archive',
                    'pdf_url': f"https://archive.org/download/{item['identifier']}/{item['identifier']}.pdf"
                })
        return results[:MAX_RESULTS]
    except Exception as e:
        print(f"Internet Archive error: {str(e)}")
        return []

def main():
    query = input("Enter book/paper title to search: ").strip()
    
    print("\nSearching free repositories...")
    results = []
    results.extend(search_gutenberg(query))
    results.extend(search_arxiv(query))
    results.extend(search_internet_archive(query))
    
    if not results:
        print("\nNo downloadable content found in free repositories")
        return
    
    print("\nAvailable Downloads:")
    for idx, item in enumerate(results, 1):
        print(f"{idx}. {item['title']} by {item['author']} ({item['source']})")
    
    try:
        choice = int(input("\nEnter number to download: "))
        selected = results[choice-1]
    except (ValueError, IndexError):
        print("Invalid selection")
        return
    
    if selected['source'] == 'Project Gutenberg':
        formats = selected['formats']
        print("\nAvailable Formats:")
        format_list = sorted(formats.keys(), key=lambda x: x.split('.')[-1])
        
        for idx, fmt in enumerate(format_list, 1):
            print(f"{idx}. {fmt.split('.')[-1].upper()}")
        
        try:
            fmt_choice = int(input("Select format: ")) - 1
            url = formats[format_list[fmt_choice]]
            ext = format_list[fmt_choice].split('.')[-1]
            filename = f"{sanitize_filename(selected['title'])}.{ext}"
        except (ValueError, IndexError):
            print("Invalid format selection")
            return
        
        success = handle_download(url, filename)
    elif selected['source'] in ['arXiv', 'Internet Archive']:
        if not selected.get('pdf_url'):
            print("No PDF available for this item")
            return
        filename = f"{sanitize_filename(selected['title'])}.pdf"
        success = handle_download(selected['pdf_url'], filename)
    
    if success:
        print("\nDownload completed successfully")
    else:
        print("\nDownload failed")

if __name__ == "__main__":
    main()
EOF

# Run the Python script
python3 "$SCRIPT_PATH"

# Clean up the temporary script
rm "$SCRIPT_PATH"

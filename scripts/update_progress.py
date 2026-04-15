#!/usr/bin/env python3
import os
from datetime import datetime

# Path to plane.html
html_file = 'Plane&Excection/plane.html'

# Read the file
with open(html_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Find and update the footer or add a last updated timestamp
# For example, update the footer text
now = datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')

# Replace a placeholder or add to footer
if 'Last updated:' in content:
    # Update existing
    import re
    content = re.sub(r'Last updated: .*? \|', f'Last updated: {now} |', content)
else:
    # Add after the existing footer
    content = content.replace(
        '<p>HCMS Blueprint · Intelligent Health Claims Management System · v1.0 MVP · 7-Day Build Plan</p>',
        f'<p>HCMS Blueprint · Intelligent Health Claims Management System · v1.0 MVP · 7-Day Build Plan</p>\n        <p>Last updated: {now}</p>'
    )

# Write back
with open(html_file, 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated plane.html with latest timestamp")
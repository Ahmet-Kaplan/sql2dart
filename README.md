# sql2dart
Generate dart type definitions from PostgreSQL database schema (MVP)


## Installation:

The package can be installed as follow:

```
[~] dart pub global activate sql2dart
```


## Usage:

Within a dart/flutter project directory, you can run one of the following examples: 

- generate data classes for public schema (default)
  ```
  sql2dart -c postgresql://postgres:postgres@localhost:54322/postgres -o path/to/output/directory
  ```
- generate for data classes for a "cms" schema 
  ```
  sql2dart -c <connection-string> -o <output-dir> -s cms
  ```

- generate data classes for specific tables from public schema (format sensitive): 
  ```
  sql2dart -c <connection-string> -o <output-dir> -t "users","posts"
  ```
  or
  ```
  sql2dart -c <connection-string> -o <output-dir> --schema=api --tables="profiles","posts"
  ```


## Sample Output:

The following folder: [example/sample_output](https://github.com/osaxma/sql2dart/tree/main/example/sample_output) contains a sample output from Supabase's `auth` schema.
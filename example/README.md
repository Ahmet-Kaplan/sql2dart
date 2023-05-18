The [sample output](https://github.com/osaxma/sql2dart/tree/main/example/sample_output) was generated for the auth schema of supabase with following command:

- From the project root directory, run:
```
dart bin/sql2dart.dart -c postgresql://postgres:postgres@localhost:54322/postgres -o example/sample_output -s auth 
```

> Note: make sure `supabase start` is running. 
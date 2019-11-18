# AdventureWorks Workload Generator

Executes a read-only workload of random selects against the AdventureWorks2017 database.

Based on the original by [Jonathan Kehayias](https://www.sqlskills.com/blogs/jonathan/the-adventureworks2008r2-books-online-random-workload-generator/).

Random select statements taken from [MSDN](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-examples-transact-sql?view=sql-server-ver15).

## Running the workload generator

Execute `./RunWorkload.ps1` in the same directory as `AdventureWorks2017BOLWorkload.sql` with the following parameters:

- `ServerName`
- `DBName`
- `Username`
- `Password`
- `parallelism`: The number of SQL statements to run in parallel
- `sleepIntervalMs`: How long to sleep between executions within the same job.

You can tune the aggressiveness by increasing parallelism and reducing sleepIntervalMs

For best results, run the workload generator on a different server.

## Extending

You can add your own scripts by simply appending them to the `AdventureWorks2017BOLWorkload.sql` file. Ensure each script is seperated with `---------`.

Note: `GO` batch seperators are not supported.
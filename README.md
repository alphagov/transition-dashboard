Dashboard for displaying information relating to the progress of Transition


__Getting Started__

To install and start the dashboard, follow these instructions.

This is made using Dashing (http://shopify.github.io/dashing/), a Sinatra-based dashboard framework.

1. Clone this repository and `$ bundle install` its gems.
2. There's an environment variable that holds the key of the specific spreadsheet so as to not to make it public. You'll need to set this otherwise the data retrieval will fail.
3. Then, type `$ dashing start` and navigate in your browser to `localhost:3030`.
4. That's all!

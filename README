# Bolt
Bolt is an open source static site generator written in Ruby. Bolt was created as no current static site generators could execute code dynamically a site compile time &mdash; with Bolt at compile time you can pull in records from your database, make http requests, prompt the user for information, etc.

## Getting Started
To get started with Bolt simply install the gem as follows:

        gem install benofsky-bolt

This installs a command line tool 'bolt' and all the tools you need to use bolt. To create a site you use the 'create' command:

        bolt create my_site
        
A directory called "my_site" will be created, if it does not already exist, and populated with the standard bolt structure like follows:

        Created my_site/
        Created my_site/pages
        Created my_site/views
        Created my_site/lib
        Created my_site/resources
        Created my_site/config.yml

Lets explain what each of these do.

### Pages
Pages contain the primary logic used to create pages for your site. Bolt will load any ruby files in the pages directory (but not subdirectories) you may lay out your site however you want, you may want only one page file, or you may want 100.

A page file is just a standard ruby file and looks something like this:

        page "index" do 
          render "home"
        end

For each "page" block one HTML file will be generated, the above will generate an 'index.html' file in the root directory of your compiled site. The string following the page method defines the *name and location* of the HTML file, you can use this to create sub directories in your Bolt site, for example:

        page "products/milk" do
          ...
        end
        
The above would generate a 'products/milk.html' when compiling your site. Since page files are just Ruby code, you can do anything in them such as pull in records from a database. Any instance variables set in a page block are made available to your view (which we will get to in a minute) as local variables.

### Views
Views define the markup used to generate your pages and are written in the HAML (see [the haml website](http://haml-lang.com/) for documentation on writing HAML.) markup language (which compiles to HTML). Every Bolt site must have a primary view, by default called "application.haml". This is definable in your config.yml file in the root directory of your Bolt site.

So lets create ours:

          $ touch views/application.html

The simplest "application.haml" one can have must contain one line as follows:

          =content

Contained within the 'content' variable at compile time will be the markup of the individual page we are currently compiling (hopefully this will make more sense in a minute). Above in the pages example you saw we had the line "render 'home'", the render command when called in pages, tells bolt to render a HAML view. Lets create the home view now.

          $ touch views/home.haml

Lets put a friendly message in it now:

          %p Hello World

When we are building are site, Bolt will compile this file and then insert the compiled HAML (which is HTML) into the place holder in 'application.haml'. This allows you to put all the markup defining the general design and layout of your site into one file and then the individual per-page markup into separate files.

Views can be used multiple times by as many pages as necessary.

### Lib
The lib directory is a place where you can place common code that is shared among several pages and load it at runtime.

### Resources
The resources directory is where you place all your stylesheets and images. The whole of the resources directory is copied to the root directory of the compiled site at compile time.

### Config.yml
Config.yml is the primary (and only) config file for your Bolt site. It defines what the default view is (as mentioned above) any other configuration options are made available as local variables within your HAML templates.

## Compiling your Bolt Site
Now we know all about the different bits in Bolt, we are ready to build a site. We do this simply by ensuring we are in the root directory of our Bolt site and run the following command:

          bolt build

          Removed ./out
          Created ./out
          Copied ./resources to out
          Parsed config ./config.yml
          Parsing page ./pages/home.rb
          Created out/index.html

Your whole Bolt site should now be compiled into various HTML files in the out directory, you can copy this directory to a web server or just view the files in your web browser.

---

I hope this somewhat sparse documentation helped, if you have any comments/questions/suggestions just send me a mail at hello@benmcredmond.com or Twitter me @benofsky.
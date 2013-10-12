Image Resizer
=============

A Sinatra app which will accept an image url, width and height, returning a png of the image resized to those dimensions.

Dependancies
=============

Sinatra
ImageMagick
RMagick

To Run
=============

This application can be run in any rack server enviorment. 
There exists a Gemfile in the root directory, so the command 'bundle install' will ensure all gems are installed and in their place.

Once the bundle is complete, the command 'rackup' will start the server. A port number may be specified with the '-p' flag.
In production, I recomend running this app in Phusion Passenger (https://www.phusionpassenger.com).

Testing
==============

To run the tests provided with this app, simply run 'rake' from anywhere within the app. The tests are it's default task.

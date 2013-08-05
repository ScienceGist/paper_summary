# PaperSummary

PaperSummary is a gem that gets a publication's summary by accessing eLife's content. We'll add more sources as we go along.

## Installation

Add this line to your application's Gemfile:

    gem 'paper_summary'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paper_summary

## Usage

You can use PaperSummary like this:

    result = PaperSummary.summary_for('doi:10.7554/eLife.00013')

The result will be a hash similar to this one:

    { summary_text: 'Short summary text',
      summary_html: '<p>Short summary html</p>'
    }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Be sure to run the specs too.

## License

This gem is licensed under the MIT license.
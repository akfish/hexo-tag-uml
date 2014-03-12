hexo-tag-uml
===================

Render UML sequence diagram in your blog powered by [Jumly](http://jumly.tmtk.net/).

## Feature

* Sequence diagram

## Install

> npm install hexo-tag-uml --save

## Initialize

* Run in your blog project folder:

> $ hexo uml install

This command will copy necessary scripts and style sheets to proper location.

* Edit theme layout file:

Add the following line into a proper location of `.ejs` file:

```html
<%- partial('jumly') %>
```

A proper place is usually in the `<head>` section. But always make sure that there are no other reference to `jQuery` otherwise it will cause conflicts.

**Special note for hexo's landscape theme:**

You should add the above line in `_partial\after-footer.ejs`.
And remove the original jQuery reference.

* Edit `_config.yml`:

```yaml
plugins:
- hexo-tag-uml
```

## Usage

```markdown
{% uml %}
@found "You", ->
  @message "Think", ->
    @message "Write your idea", "JUMLY", ->
      @create "Diagram"
jumly.css "background-color":"#8CC84B"
{% enduml %}
```

For more information on how to write jumly syntax, visit [Jumly](http://jumly.tmtk.net/).

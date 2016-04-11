# Using bio-vcf with MongoDB

bio-vcf can output many types of formats. In this exercise we will load
Mongo with VCF data and do some queries on that.

## Install Mongo (Debian)

With su (password 'bioinformatics')

```sh
su
apt-get install mongodb
```

## Install Mongo in $HOME

Mongo comes with many distributions. Here we installed with guix. Check

```sh
guix package -A mongodb
  mongodb 3.3.3   out     gn/packages/mongodb.scm:31:2
```

Create a directory for the database

```sh
mkdir -p ~/opt/var/mongodb
mkdir -p ~/opt/etc
```

And create a configuration file ~/opt/etc/mongo.conf

```
verbose = true
port = 27017
dbpath = /home/user/opt/var/mongodb/
noauth = true
maxConns = 5
rest = true
```

and run Mongo

```sh
env LC_ALL=C mongod --config ~/opt/etc/mongo.conf
```

```ruby
use admin
db.createUser({user:"admin", pwd:"admin123", roles:[{role:"root", db:"admin"}]})
```

## Use client

mongo
use admin
db.createUser({user:"admin", pwd:"admin123", roles:[{role:"root", db:"admin"}]})

## Tutorial Mongo

Using the example on MongoDB's [website](https://docs.mongodb.org/getting-started/shell/import-data/)

### Load data

Records look like:

```javascript
{"address": {"building": "2780", "coord": [-73.98241999999999, 40.579505], "street": "Stillwell Avenue", "zipcode": "11224"}, "borough": "Brooklyn", "cuisine": "American ", "grades": [{"date": {"$date": 1402358400000}, "grade": "A", "score": 5}, {"date": {"$date": 1370390400000}, "grade": "A", "score": 7}, {"date": {"$date": 1334275200000}, "grade": "A", "score": 12}, {"date": {"$date": 1318377600000}, "grade": "A", "score": 12}], "name": "Riviera Caterer", "restaurant_id": "40356018"}
{"address": {"building": "351", "coord": [-73.98513559999999, 40.7676919], "street": "West   57 Street", "zipcode": "10019"}, "borough": "Manhattan", "cuisine": "Irish", "grades": [{"date": {"$date": 1409961600000}, "grade": "A", "score": 2}, {"date": {"$date": 1374451200000}, "grade": "A", "score": 11}, {"date": {"$date": 1343692800000}, "grade": "A", "score": 12}, {"date": {"$date": 1325116800000}, "grade": "A", "score": 12}], "name": "Dj Reynolds Pub And Restaurant", "restaurant_id": "30191841"}
```

Note there are no specific identifiers. Or are there?

```sh
wget https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/primer-dataset.json
mongoimport --db test --collection restaurants --drop --file primer-dataset.json
Mon Apr 11 00:24:50.963 dropping: test.restaurants
Mon Apr 11 00:24:52.375 check 9 25359
Mon Apr 11 00:24:52.448 imported 25359 objects
```

### Use the shell

Run the mongo shell with

```sh
mongo
```

```ruby
use test
db.restaurants.find()
db.restaurants.find( { "borough": "Manhattan" } )
db.restaurants.find( { "grades.score": { $gt: 30 } } )
... AND ...
db.restaurants.find( { "cuisine": "Italian", "address.zipcode": "10075" ,"grades.score": { $gt: 30 }} )
... OR ...
db.restaurants.find(
   { $or: [ { "cuisine": "Italian" }, { "address.zipcode": "10075" } ] }
)
... SORT ...
db.restaurants.find().sort( { "borough": 1, "address.zipcode": 1 } )
... Count ...
db.restaurants.aggregate(
   [
     { $group: { "_id": "$borough", "count": { $sum: 1 } } }
   ]
   );

db.restaurants.aggregate(
   [
     { $match: { "borough": "Queens", "cuisine": "Brazilian" } },
     { $group: { "_id": "$address.zipcode" , "count": { $sum: 1 } } }
   ]
   );
... Index ...
db.restaurants.createIndex( { "cuisine": 1, "address.zipcode": -1 } )
```

### Prepare template with bio-vcf

```sh
wget https://github.com/pjotrp/bioruby-vcf/raw/master/test/data/input/gatk_exome.vcf
cat gatk_exome.vcf |bio-vcf --eval '[r.chr,r.pos]'
```

Let's create a template named gatk_template.json

```ruby

{
            "chr": "<%= rec.chrom %>",
            "pos": <%= rec.pos %>,
            "ref": "<%= rec.ref %>",
            "alt": "<%= rec.alt[0] %>",
            "dp":  <%= rec.info.dp %>
}
```

And run it

```sh
cat gatk_exome.vcf |bio-vcf --template gatk_template.json |less
cat gatk_exome.vcf |bio-vcf --template gatk_template.json > gatk_exome.json
```

Looks like

```
{
  "rec": {
            "chr": "X",
            "pos": 134713855,
            "ref": "G",
            "alt": "A",
            "dp":  4
   }
}
```

Import into mongo

```sh
mongoimport --db gatk --collection vcf --drop --file gatk_exome.json
mongoimport --db gatk --collection vcf --drop --file gatk_exome.json --jsonArray
```

```ruby
use gatk
db.vcf.find()
db.vcf.find( { "rec.chr": "X" } )
db.vcf.find( { "rec.chr": "X" } ).count()
3
db.vcf.find( { "rec.dp": { $gt: 5 }}  )
db.vcf.find( { "rec.dp": { $gt: 5 }}  ).count()
25
```

Comparable bio-vcf statements

```
cat gatk_exome.vcf |bio-vcf --eval '[r.chr,r.pos,r.ref,r.alt,r.info.dp]' --filter "r.chr=='X'"|grep -v '#' |wc -l
=>"[r.chr,r.pos,r.ref,r.alt,r.info.dp]", :filter=>"r.chr=='X'"}
3
cat gatk_exome.vcf |bio-vcf --eval '[r.chr,r.pos,r.ref,r.alt,r.info.dp]' --filter "r.info.dp>5"|grep -v '#' |wc -l
=>"[r.chr,r.pos,r.ref,r.alt,r.info.dp]", :filter=>"r.info.dp>5"}
25
```

Exercise 1.

With bio-vcf take the field "Variant Confidence/Quality by Depth" and
filter on QD>12.0. How many matches? Answer 112 out of 175

Exercise 2.

Do the same with MongoDB. So you can do

```ruby
db.vcf.find( { "rec.qd": { $gt: 12.0 }}  ).count()
112
```

## Now for some real data

Let's use our PIK3CA data in two 

```
cat gene_PIK3CA.vcf |bio-vcf --samples 2,3  --seval s.dp
cat gene_PIK3CA.vcf |bio-vcf --sfilter-samples 2,3  --seval s.dp --sfilter "s.dp>7"
cat gene_PIK3CA.vcf |bio-vcf --sfilter-samples 0,3 --sfilter 's.dp>20' --seval s.dp
3       178916645       24      39
3       178916651       30      31
3       178921407       32      43
3       178936082       24      24
3       178936091       27      32
3       178947904       23      33
3       178952072       38      45
3       178952085       35      45
3       178952088       34      45
```

Looking at annotations

```
cat gene_PIK3CA.vcf |bio-vcf --eval [r.chr,r.pos,r.info.ann] |grep ENST00000263967|wc -l
30
```

alternative

```
cat gene_PIK3CA.vcf |bio-vcf --eval '[r.chr,r.pos,r.info.ann]' --filter 'r.info.ann =~ /ENST00000263967/' --seval 's.dp'
3       178921407       T|synonymous_variant|LOW|PIK3CA|ENSG00000121879|transcript|ENST00000263967|protein_coding|5/21|c.889C>T|p.Leu297Leu|1046/9093|889/3207|297/1068||    32      32      38      43      27      34      30      37      32      36      44      37  25       27      43      30      11      23      19      37      28      17      13 ...
```

Let's try and do the same with Mongo

```
{
  "rec": {
            "chr": "<%= rec.chrom %>",
            "pos": <%= rec.pos %>,
            "ref": "<%= rec.ref %>",
            "alt": "<%= rec.alt[0] %>",
            "dp":  <%= rec.info.dp %>,
            "ann":  "<%= rec.info.ann %>"
   }
}
```

```sh
mongoimport --db PIK3CA --collection vcf --drop --file PIK3CA.json --jsonArray
```

```ruby
db.vcf.find({"rec.ann": /ENST00000263967/i }).count()
30
```

## Load results into Python

```sh
guix package -i python2-pip
export PYTHONPATH="/home/user/.guix-profile/lib/python2.7/site-packages"
pip install pymongo
pip install --install-option="--prefix=$HOME/opt/python" pymongo
export PYTHONPATH="/home/user/.guix-profile/lib/python2.7/site-packages:$HOME/opt/python/lib/python2.7/site-packages"
```

```python
from pymongo import MongoClient

client = MongoClient()
db = client.test
# cursor = db.restaurants.find()
cursor = db.restaurants.find({"borough": "Manhattan"})
for document in cursor:
    print(document)
    print(document["cuisine"])
    print(document["grades"][0]["score"]>10)

```

## Exercise 1

Write a Python script which queries the PIK3CA VCF file for the annotation as in


```ruby
db.vcf.find({"rec.ann": /ENST00000263967/i }).count()
30
```

## Exercise 2

Write a Python mongo script which queries the PIK3CA file for something
similar to

```sh
cat gene_PIK3CA.vcf |bio-vcf --sfilter-samples 2,3  --seval s.dp --sfilter "s.dp>7"
```

when the bio-vcf template is

```ruby

{
  "rec": {
            "chr": "<%= rec.chrom %>",
            "pos": <%= rec.pos %>,
            "ref": "<%= rec.ref %>",
            "alt": "<%= rec.alt[0] %>",
            "dp":  <%= rec.info.dp %>,
            "samples": [
              <%=
              a = []
              rec.each_sample { |s| a.push s.dp }
              a.join(',')
              %>
   ]
  }
}
```

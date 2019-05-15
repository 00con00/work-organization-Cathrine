
library("tidyverse")

#first way to type it
data(BCI, package = "vegan")
x11()
plot(sort(colSums(BCI), decreasing = TRUE))

#second way to type it
x1 <- colSums(BCI)
x2 <- sort(x1, decreasing =TRUE)
plot(x2)

#third way to type it
BCI %>% 
  colSums() %>% 
  sort(decreasing = TRUE) %>% 
  plot()

#type ctrl shift m in order to create pipes
#type tab to get up arguments

#task 2####
iris <- as_tibble(iris)   #tibble makes it print better, and only the first 10 rows
iris

#select 
iris %>% select(Sepal.Length, Species) #pipe puts iris inside select same as: 
# select(iris, Sepal.Length, Species)

#if one want to get rid of something can put a minus sign infront.
#the solumn is taken out of the analysis
iris %>% select(-Sepal.Width)
iris %>% select(Sepal.Length:Petal.Length)

#renaming the column name the second part of the parenthesis will take the name before the parenthesis
iris %>% rename(sepal_length = Sepal.Length, spp = Species)

#select some rows
iris %>% filter(Sepal.Length > 5, Petal.Length < 2) %>% 
  select(Species)

#mutate in order to make change, for example by making a new by take two together
iris %>% mutate(petal.area = Petal.Length * Petal.Width)
iris %>% mutate(Species = toupper(Species)) #all the letters become uppercase in species column

#  can make new columns with data that has been summarised
iris %>% group_by(Species) %>% 
  summarise(mean_petal_lenght = mean(Petal.Length), sd_petal_length = sd(Petal.Length))


#adding the mean data as a column to the origianl data
iris %>% group_by(Species) %>% 
  mutate(mean_petal_lenght = mean(Petal.Length)) %>% 
  ungroup   #now a tibble with no groups. If it gets summarasied will only get one row

# grouping of data
iris %>% arrange(Petal.Length)
iris %>% arrange(desc(Petal.Length)) #groped in descending order

iris %>% group_by(Species) %>% arrange(Petal.Length) %>% slice(1:3) #pulling out the the top row to look at it. Can only be done after arranging the grouping of the data
#by adding a minus before 1:3 it is possible to slice out the three top most rows

iris %>% group_by(Species) %>% nest() #grouped into three different groups based on the species. It's a tibble inside a tibble

iris %>% group_by(Species) %>% 
  nest() %>% 
  mutate(mod = map(data, ~lm(Sepal.Length ~ Sepal.Width, data = .))) %>% 
  mutate(coef = map(mod, broom::tidy)) %>% 
  unnest(coef)
#we took the grouped species and nested them just like line 64
#map is taking tibble data one column at a time, and fixing each of them with a linear model. 
#the second mutate line pulling the coeeficient out of the model
#third line is unraveling the data in order to see the data

#gather, spread
iris %>% 
  rownames_to_column() %>% 
  gather(key = variable, value = measurement, -Species, -rowname) %>% 
  group_by(Species, variable) %>% 
  summarise(mean = mean(measurement))

#tidy data one sepecies per row

iris %>% 
  rownames_to_column() %>% 
  gather(key = variable, value = measurement, -Species, -rowname) %>% 
  ggplot(aes(x = variable, y = measurement, fill = Species)) + geom_violin()

#same as from 77 but this time the data is plotted 





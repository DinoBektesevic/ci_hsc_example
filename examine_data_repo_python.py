from lsst.daf.butler import Butler

# get a Butler to the repo
butler = Butler("butler_repo/butler.yaml")


# Let's do some querying. Let's do the same
# kind we did in the terminal first

print(
    butler.registry.queryCollections()
)
print()


# we won't print all of them again because a wall of text
print(
    butler.registry.queryDatasetTypes("calexp")
)
print()


# So basically you get the same things as before just as
# Python objects, let's skip forward and query a single image
# for example:
exp = butler.get(
        "calexp",
        dataId={
            "instrument":"HSC",
            "visit":903334,
            "detector":16,
        },
        collections="HSC/runs/ci_hsc"
)


print(exp)
print(exp.image)
print()


# There we go, loading and inspecting datasets straight from python

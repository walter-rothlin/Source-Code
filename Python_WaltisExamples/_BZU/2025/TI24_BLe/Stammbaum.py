from graphviz import Digraph


def create_stammbaum():
    # Create a directed graph
    stammbaum = Digraph("Family_Tree", format="png")

    # Define family members
    stammbaum.node("G1A", "Great-Grandfather")
    stammbaum.node("G1B", "Great-Grandmother")

    stammbaum.node("G2A", "Grandfather")
    stammbaum.node("G2B", "Grandmother")

    stammbaum.node("G2C", "Granduncle")

    stammbaum.node("P1", "Father")
    stammbaum.node("P2", "Mother")

    stammbaum.node("C1", "Child 1")
    stammbaum.node("C2", "Child 2")

    # Create relationships
    stammbaum.edge("G1A", "G2A")
    stammbaum.edge("G1B", "G2A")

    stammbaum.edge("G1A", "G2C")
    stammbaum.edge("G1B", "G2C")

    stammbaum.edge("G2A", "P1")
    stammbaum.edge("G2B", "P1")

    stammbaum.edge("P1", "C1")
    stammbaum.edge("P1", "C2")
    stammbaum.edge("P2", "C1")
    stammbaum.edge("P2", "C2")

    # Render the family tree
    stammbaum.render("stammbaum", view=True)


# Run the function
if __name__ == "__main__":
    create_stammbaum()

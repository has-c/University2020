from textbook.backtracking_search_solver import *
from textbook.min_conflicts_solver import *

#####################
# Your imports here #
#####################


def backtracking_search_instrumented(
        csp,
        select_unassigned_variable=first_unassigned_variable,
        order_domain_values=unordered_domain_values,
        inference=no_inference,
        max_steps=100_000,
    ):
    """Return a dict where the key 'assignment' is identical to to result of backtracking_search(csp, select_unassigned_variable, ...).

    The key 'num_assignments' == the number of times csp.assign is called.
    The key 'num_backtracks' == the number of backtracks performed.
    """
    ######################
    ### Your code here ###
    ######################
    return {
        "assignment": dict or None,
        "num_assignments": int,
        "num_backtracks": int,
    }


def min_conflicts_instrumented(csp, max_steps=100_000):
    """Return a dict where the key 'assignment' is identical to to result of min_conflicts(csp, max_steps).

    The key 'num_assignments' == the number of times csp.assign is called.
    The key 'num_repair_assignments' == the number of assignments made outside of generating the initial assignment of variables.
    """
    ######################
    ### Your code here ###
    ######################
    return {
        "assignment": dict or None,
        "num_assignments": int,
        "num_repair_assignments": int,
    }

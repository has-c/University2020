"""
Call test_all() to test your instrumented functions.
Call get_assignment_results() to generate data required for Part B.
The dictionary returned by get_assignment_results has the same format as the `examples` dictionary in this file.
"""
import random
import re
from functools import partial, wraps
from typing import Callable, Dict, Any, TypeVar

from instrumented_solvers import (
    min_conflicts_instrumented,
    backtracking_search_instrumented,
)
from textbook.backtracking_search_solver import (
    first_unassigned_variable,
    mrv,
    unordered_domain_values,
    lcv,
    no_inference,
    forward_checking,
    mac,
)
from textbook.problems import (
    australia_csp,
    france_csp,
    usa_csp,
    NQueensCSP,
    Zebra,
)

from instrumented_solvers_answer import (
    min_conflicts_instrumented,
    backtracking_search_instrumented,
)


SEED = 42  # seed used to generate `examples`
MAX_STEPS = 1000  # max steps required for assignment
VERBOSE = True

examples = {
    "(min_conflicts_instrumented, max_steps=1000)": {
        "australia_map": {
            "num_assignments": [6],
            "num_repair_assignments": [0],
        },
        "france_map": {
            "num_assignments": [21],
            "num_repair_assignments": [0],
        },
        "zebra": {
            "num_assignments": [1025],
            "num_repair_assignments": [1000],
        },
        "5 queens": {
            "num_assignments": [5],
            "num_repair_assignments": [0],
        },
        "7 queens": {
            "num_assignments": [14],
            "num_repair_assignments": [7],
        },
        "9 queens": {
            "num_assignments": [40],
            "num_repair_assignments": [31],
        },
        "11 queens": {
            "num_assignments": [32],
            "num_repair_assignments": [21],
        },
        "13 queens": {
            "num_assignments": [48],
            "num_repair_assignments": [35],
        },
    },
    "(backtracking_search_instrumented, select_unassigned_variable=first_unassigned_variable, order_domain_values=unordered_domain_values, inference=no_inference, max_steps=1000)": {
        "australia_map": {
            "num_assignments": [6],
            "num_backtracks": [0],
        },
        "france_map": {"num_assignments": [21], "num_backtracks": [0]},
        "zebra": {"num_assignments": [1000], "num_backtracks": [987]},
        "5 queens": {"num_assignments": [5], "num_backtracks": [0]},
        "7 queens": {"num_assignments": [10], "num_backtracks": [3]},
        "9 queens": {"num_assignments": [48], "num_backtracks": [39]},
        "11 queens": {"num_assignments": [48], "num_backtracks": [37]},
        "13 queens": {
            "num_assignments": [109],
            "num_backtracks": [96],
        },
    },
    "(backtracking_search_instrumented, select_unassigned_variable=first_unassigned_variable, order_domain_values=unordered_domain_values, inference=forward_checking, max_steps=1000)": {
        "australia_map": {
            "num_assignments": [6],
            "num_backtracks": [0],
        },
        "france_map": {"num_assignments": [21], "num_backtracks": [0]},
        "zebra": {"num_assignments": [1000], "num_backtracks": [650]},
        "5 queens": {"num_assignments": [5], "num_backtracks": [0]},
        "7 queens": {"num_assignments": [9], "num_backtracks": [0]},
        "9 queens": {"num_assignments": [39], "num_backtracks": [13]},
        "11 queens": {"num_assignments": [36], "num_backtracks": [11]},
        "13 queens": {"num_assignments": [87], "num_backtracks": [41]},
    },
    "(backtracking_search_instrumented, select_unassigned_variable=first_unassigned_variable, order_domain_values=unordered_domain_values, inference=mac, max_steps=1000)": {
        "australia_map": {
            "num_assignments": [6],
            "num_backtracks": [0],
        },
        "france_map": {"num_assignments": [21], "num_backtracks": [0]},
        "zebra": {"num_assignments": [1000], "num_backtracks": [989]},
        "5 queens": {"num_assignments": [5], "num_backtracks": [0]},
        "7 queens": {"num_assignments": [7], "num_backtracks": [0]},
        "9 queens": {"num_assignments": [33], "num_backtracks": [24]},
        "11 queens": {"num_assignments": [22], "num_backtracks": [11]},
        "13 queens": {"num_assignments": [61], "num_backtracks": [48]},
    },
    "(backtracking_search_instrumented, select_unassigned_variable=mrv, order_domain_values=lcv, inference=no_inference, max_steps=1000)": {
        "australia_map": {
            "num_assignments": [6],
            "num_backtracks": [0],
        },
        "france_map": {
            "num_assignments": [733],
            "num_backtracks": [712],
        },
        "zebra": {"num_assignments": [1000], "num_backtracks": [986]},
        "5 queens": {"num_assignments": [5], "num_backtracks": [0]},
        "7 queens": {"num_assignments": [7], "num_backtracks": [0]},
        "9 queens": {"num_assignments": [56], "num_backtracks": [47]},
        "11 queens": {"num_assignments": [14], "num_backtracks": [3]},
        "13 queens": {"num_assignments": [53], "num_backtracks": [40]},
    },
    "(backtracking_search_instrumented, select_unassigned_variable=mrv, order_domain_values=lcv, inference=mac, max_steps=1000)": {
        "australia_map": {
            "num_assignments": [6],
            "num_backtracks": [0],
        },
        "france_map": {"num_assignments": [21], "num_backtracks": [0]},
        "zebra": {"num_assignments": [46], "num_backtracks": [21]},
        "5 queens": {"num_assignments": [5], "num_backtracks": [0]},
        "7 queens": {"num_assignments": [9], "num_backtracks": [2]},
        "9 queens": {"num_assignments": [10], "num_backtracks": [1]},
        "11 queens": {"num_assignments": [11], "num_backtracks": [0]},
        "13 queens": {"num_assignments": [14], "num_backtracks": [1]},
    },
}

# types for annotations
Problem = TypeVar("Problem")
ProblemConstructor = Callable[[], Problem]
Solver = Callable[[Problem], Dict[str, Any]]
Results = Dict[str, Dict[str, Dict[str, list]]]
Errors = Dict[str, Dict[str, Dict[str, Any]]]
Test = Callable[..., Errors]


def test_all() -> None:
    """Test all required solvers on test problems. Call get_test_errors() to return errors dict."""
    get_test_errors()


def get_test_errors() -> Errors:
    """Return errors from comparing instrumented solver output to `examples`."""
    results = get_test_results()
    return get_errors(results, examples)


def get_test_results() -> Results:
    """Return dictionary of results for comparison to `examples`."""
    return get_results(
        solvers=get_solvers(
            min_conflicts_instrumented,
            backtracking_search_instrumented,
            max_steps=MAX_STEPS,
        ),
        problems=get_test_problems(),
    )


def get_assignment_results() -> Results:
    """Return dictionary of results required for Part B, assuming instrumented functions are implemented correctly."""
    return get_results(
        solvers=get_solvers(
            min_conflicts_instrumented,
            backtracking_search_instrumented,
            max_steps=MAX_STEPS,
        ),
        problems=get_assignment_problems(),
        num_trials=10,
    )


def get_test_problems() -> Dict[str, ProblemConstructor]:
    """Return dictionary of problems used to generate `examples`.

    Note: this problem set is NOT identical to the ones you're required to run for assignment Part B.
    """
    ret = {
        "australia_map": australia_csp,
        "france_map": france_csp,
        "zebra": Zebra,
    }
    for n_queens in [5, 7, 9, 11, 13]:
        ret[str(n_queens) + " queens"] = partial(NQueensCSP, n_queens)
    return ret


def get_assignment_problems() -> Dict[str, ProblemConstructor]:
    """Return the problems required for part B, in the form required by get_results."""
    ret = {
        "australia_map": australia_csp,
        "usa_csp": usa_csp,
        "zebra": Zebra,
    }
    for n_queens in [10, 30, 50, 70, 90]:
        ret[str(n_queens) + " queens"] = partial(NQueensCSP, n_queens)
    return ret


def get_results(
    solvers: Dict[str, Solver],
    problems: Dict[str, ProblemConstructor],
    num_trials: int = 1,
) -> Results:
    """Return dictionary of results in form {solver: {problem: result_dict}}"""
    results: Results = {solver_name: {} for solver_name in solvers}
    for solver_name, solver in solvers.items():
        for problem_name, problem_constructor in problems.items():
            print(f"{solver_name}({problem_name})")
            results[solver_name][problem_name] = get_trial_results(
                solver, problem_constructor, num_trials
            )
    return results


def get_trial_results(
    solver: Solver,
    problem_constructor: ProblemConstructor,
    num_trials: int,
) -> Dict[str, list]:
    """Return result dict in form {key: [values]}"""
    assert num_trials >= 1
    random.seed(SEED)
    results = [
        solver(problem_constructor()) for _ in range(num_trials)
    ]
    return {
        key: [result[key] for result in results] for key in results[0]
    }


def get_solvers(
    min_conflicts_solver=min_conflicts_instrumented, backtracking_solver=backtracking_search_instrumented, max_steps=MAX_STEPS,
) -> Dict[str, Solver]:
    """Return solvers required for the assignment."""
    return {
        pretty(solver): solver
        for solver in [
            partial(min_conflicts_solver, max_steps=max_steps),
            partial(
                backtracking_solver,
                select_unassigned_variable=first_unassigned_variable,
                order_domain_values=unordered_domain_values,
                inference=no_inference,
                max_steps=max_steps,
            ),
            partial(
                backtracking_solver,
                select_unassigned_variable=first_unassigned_variable,
                order_domain_values=unordered_domain_values,
                inference=forward_checking,
                max_steps=max_steps,
            ),
            partial(
                backtracking_solver,
                select_unassigned_variable=first_unassigned_variable,
                order_domain_values=unordered_domain_values,
                inference=mac,
                max_steps=max_steps,
            ),
            partial(
                backtracking_solver,
                select_unassigned_variable=mrv,
                order_domain_values=lcv,
                inference=no_inference,
                max_steps=max_steps,
            ),
            partial(
                backtracking_solver,
                select_unassigned_variable=mrv,
                order_domain_values=lcv,
                inference=mac,
                max_steps=max_steps,
            ),
        ]
    }


def pretty(solver) -> str:
    """Get prettier name from str of solver."""
    return re.sub(
        " at 0x[0-f]*>",
        "",
        str(solver)
        .replace("<function ", "")
        .replace("functools.partial", ""),
    )


def verbose_test(test: Test) -> Test:
    """Decorate test to print pass/fail and errors."""
    @wraps(test)
    def wrapper(*args, **kwargs) -> Errors:
        errors = test(*args, **kwargs)
        if not VERBOSE:
            return errors
        if not errors:
            print("PASSED:", test.__name__)
            return errors
        print()
        print("FAILED:", test.__name__)
        for solver, solver_errors in errors.items():
            for problem, error in solver_errors.items():
                print("\t", "solver: ", solver, sep="")
                print("\t", "problem: ", problem, sep="")
                print("\tyour result:", error["result"])
                print("\ttrue result:", error["example_result"])
                if "keys" in error:
                    print("\tthese keys were in error:", error["keys"])
                print()
        return errors

    return wrapper


@verbose_test
def get_errors(results: Results, ground_truth: Results) -> Errors:
    """Return dictionary of errors from comparing results dict to ground_truth."""
    errors: Errors = {}
    for solver_name, example_problem_results in ground_truth.items():
        for (
            problem_name,
            example_result,
        ) in example_problem_results.items():
            result = results[solver_name][problem_name]
            keys = []
            for key, value in example_result.items():
                if result[key] != value:
                    keys.append(key)
            if keys:
                if solver_name not in errors:
                    errors[solver_name] = {}
                errors[solver_name][problem_name] = {
                    "example_result": example_result,
                    "result": result,
                    "keys": keys,
                }
    return errors

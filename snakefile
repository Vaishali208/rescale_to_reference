query_file = "shuf.a.bed.gz"
reference_file = "reference.hist"
max_fragment_length_file = "data/max_fragment_length.txt"
adjusted_reference_file = "data/adjusted_reference.hist"
plot_file = "distribution_plot.png"

rule all:
    input:
        plot_file

rule calculate_max_fragment_length:
    input:
        query_file
    output:
        max_fragment_length_file
    shell:
        """
        zcat {input} | awk '{{print $4}}' | sort -nr | head -n 1 > {output}
        """

rule adjust_reference_distribution:
    input:
        reference_file=reference_file,
        max_fragment_length=max_fragment_length_file
    output:
        adjusted_reference_file
    run:
        import pandas as pd
        max_length = float(open(input.max_fragment_length).read().strip())
        ref_df = pd.read_csv(input.reference_file, sep=r'\s+', header=None, names=["Length", "Frequency"])
        ref_df["Adjusted_Frequency"] = ref_df["Frequency"] / ref_df["Frequency"].sum() * max_length
        ref_df[["Length", "Adjusted_Frequency"]].to_csv(output[0], sep=' ', index=False, header=False)

rule plot_graph:
    input:
        query_hist=query_file,
        adjusted_reference_hist=adjusted_reference_file
    output:
        plot_file
    script:
        "plot_graph.py"


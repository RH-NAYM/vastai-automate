import pandas as pd

def parse_txt_file(file_path):
    with open(file_path, 'r') as f:
        headers = f.readline().strip().split()
        data_list = []
        for line in f:
            values = line.strip().split()
            data_dict = dict(zip(headers, values))
            data_list.append(data_dict)
        return data_list

def main():
    file_path = 'vastai_output.txt'
    parsed_data = parse_txt_file(file_path)

    df = pd.DataFrame(parsed_data)
    
    # Convert necessary columns to float
    df['$/hr'] = df['$/hr'].astype(float)
    df['Net_up'] = df['Net_up'].astype(float)
    df['Driver'] = df['Driver'].astype(float)
    
    # Sort DataFrame by multiple columns
    sorted_dataframe = df.sort_values(by=['$/hr', 'Net_up', 'Driver'], ascending=[True, False, False])

    instance_id = []

    # Collect up to 2 valid instance IDs
    for _, details in sorted_dataframe.iterrows():
        if details['Net_up'] > 300 and details['Driver'] > 300:
            if len(instance_id) < 2:
                instance_id.append(details['ID'])
            if len(instance_id) == 1:
                break  

    # Print space-separated IDs (no brackets or quotes)
    print(" ".join(instance_id))
    
    # print(instance_id)
if __name__ == "__main__":
    main()

import os
import json
from eth_account import account
from eth_typing import abi
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st



load_dotenv()

# Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB_PROVIDER_URI")))

@st.cache(allow_output_mutation=True)

def load_contract():
	with open(Path('./contracts/compiled/Auction_abi.json')) as f:
	    auction_abi = json.load(f)
	contract_address = os.getenv("SMART_CONTRACT_ADDRESS")
	contract = w3.eth.contract(
		address=contract_address,
		abi=auction_abi
	)

	return contract

contract = load_contract()

art_database = {
    "Image1": ["Image1", "0x9d21A8554920F10790f9eF9aDbA32230BC5434b2", "New", 2, "Images/Image1.png"],
    "Image2": ["Image2", "0x9d21A8554920F10790f9eF9aDbA32230BC5434b2", "New", 2, "Images/Image2.png"],
    "Image3": ["Image3", "0x9d21A8554920F10790f9eF9aDbA32230BC5434b2", "New", 2, "Images/Image3.png"],
    "Image4": ["Image4", "0x9d21A8554920F10790f9eF9aDbA32230BC5434b2", "New", 2, "Images/Image4.png"],
    "Image5": ["Image5", "0x9d21A8554920F10790f9eF9aDbA32230BC5434b2", "New", 2, "Images/Image5.png"],
}

# A list of the artwork avaliable for Auction
art = ["Image1", "Image2", "Image3", "Image4", "Image5"]


def get_art():
    """Display the database of art information."""
    db_list = list(art_database.values())

    for number in range(len(art)):
        st.image(db_list[number][4], width=200)
        st.write("Name: ", db_list[number][0])
        st.write("Ethereum Account Address: ", db_list[number][1])
        st.write("Description: ", db_list[number][2])
        st.write("Minimum Bid: ", db_list[number][3], "eth")
        st.text(" \n")

# Streamlit Code

# Streamlit application headings
st.markdown("# NFT Auction!")
st.markdown("## Bid for your favorite Artwork!")
st.text(" \n")

# Streamlit Sidebar Code - Start
get_art()

st.sidebar.markdown("## Client Account Address and Ethernet Balance in Ether")

# Write the client's Ethereum account address to the sidebar
st.sidebar.write()

# Create a select box to chose a car to bid on
art = st.sidebar.selectbox('Select an art', art)

# Create a input field to record the initial bid
starting_bid = st.sidebar.number_input("Bid")

st.sidebar.markdown("## Art, Minimum Bid, and Ethereum Address")

# Identify the Art for auction
art = art_database[art][0]

# Write the art's name to the sidebar
st.sidebar.write(art)

# Identify the the starting bid for the art being auctioned
starting_bid = art_database[art][3]

# Write the arts starting bid
st.sidebar.write(starting_bid)

# Identify the auction owner's Ethereum Address
art_address = art_database[art][1]

# Write the inTech auction owner's Ethereum Address to the sidebar
st.sidebar.write(art_address)

if st.sidebar.button("Bid"):
    contract.functions.bid().transact({'from': account, 'gas': 3000000})

if st.sidebar.button("Withdraw"):
    contract.functions.withdraw()

if st.sidebar.button("Auction End"):
    contract.functions.auctionend()

st.sidebar.markdown("## Highest Bid in Ether")